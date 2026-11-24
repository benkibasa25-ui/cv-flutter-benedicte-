import 'dart:convert';
import 'package:http/http.dart' as http;

class MembreFamille {
  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;

  MembreFamille({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  factory MembreFamille.fromJson(Map<String, dynamic> json) {
    return MembreFamille(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nom: (json['nom'] ?? '').toString(),
      postnom: (json['postnom'] ?? '').toString(),
      prenom: (json['prenom'] ?? '').toString(),
      lieuNaissance: (json['lieu_naissance'] ?? '').toString(),
      dateNaissance: (json['date_naissance'] ?? '').toString(),
      parente: (json['parente'] ?? '').toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'nom': nom.trim(),
        'postnom': postnom.trim(),
        'prenom': prenom.trim(),
        'lieu_naissance': lieuNaissance.trim(),
        'date_naissance': dateNaissance.trim(),
        'parente': parente.trim(),
      };
}

class ApiService {
  // Note : sur émulateur Android local, utiliser http://10.0.2.2/api-test/public si localhost ne passe pas
  static const String baseUrl = 'http://localhost/api-test/public';

  static Map<String, dynamic>? currentUser;

  static Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Future> login(
      String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/accounts/login'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200 && body['success'] == true) {
      currentUser = body['data'] as Map<String, dynamic>?;
      return {'ok': true, 'message': body['message'] ?? 'Connexion réussie'};
    }
    return {
      'ok': false,
      'message': body['message'] ?? 'Email ou mot de passe incorrect',
    };
  }

  static Future> register(
      String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/accounts/register'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if ((res.statusCode == 200 || res.statusCode == 201) &&
        body['success'] == true) {
      currentUser = body['data'] as Map<String, dynamic>?;
      return {'ok': true, 'message': body['message'] ?? 'Compte créé'};
    }
    return {
      'ok': false,
      'message': body['message'] ?? 'Erreur lors de la création du compte',
    };
  }

  static Future<List<MembreFamille>> getMembres() async {
    final res = await http.get(
      Uri.parse('$baseUrl/famille-membres'),
      headers: {'Accept': 'application/json'},
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final List list = (body['data'] as List?) ?? [];
      return list
          .map((e) => MembreFamille.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    throw Exception('Erreur chargement (${res.statusCode})');
  }

  static Future<void> ajouterMembre(MembreFamille membre) async {
    final res = await http.post(
      Uri.parse('$baseUrl/famille-membres'),
      headers: _jsonHeaders,
      body: jsonEncode(membre.toJson()),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      final body = _tryDecode(res.body);
      throw Exception(body?['message'] ?? 'Erreur ajout (${res.statusCode})');
    }
  }

  static Future<void> modifierMembre(MembreFamille membre) async {
    final res = await http.put(
      Uri.parse('$baseUrl/famille-membres/${membre.id}'),
      headers: _jsonHeaders,
      body: jsonEncode(membre.toJson()),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      final body = _tryDecode(res.body);
      throw Exception(
          body?['message'] ?? 'Erreur modification (${res.statusCode})');
    }
  }

  static Future<void> supprimerMembre(int id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/famille-membres/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      final body = _tryDecode(res.body);
      throw Exception(
          body?['message'] ?? 'Erreur suppression (${res.statusCode})');
    }
  }

  static Map<String, dynamic>? _tryDecode(String source) {
    try {
      final decoded = jsonDecode(source);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }
}
