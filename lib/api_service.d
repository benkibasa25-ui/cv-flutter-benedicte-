import 'dart:convert';
import 'package:http/http.dart' as http;

//Demostration ajout dans le code

class Membre {
  int id;
  String nom, postnom, prenom, lieu, date, parente;
  Membre({
    this.id = 0,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieu,
    required this.date,
    required this.parente,
  });

  factory Membre.fromJson(Map<String, dynamic> j) => Membre(
        id: int.tryParse('${j['id']}') ?? 0,
        nom: '${j['nom'] ?? ''}',
        postnom: '${j['postnom'] ?? ''}',
        prenom: '${j['prenom'] ?? ''}',
        lieu: '${j['lieu_naissance'] ?? ''}',
        date: '${j['date_naissance'] ?? ''}',
        parente: '${j['parente'] ?? ''}',
      );

  Map<String, dynamic> toJson() => {
        'nom': nom.trim(),
        'postnom': postnom.trim(),
        'prenom': prenom.trim(),
        'lieu_naissance': lieu.trim(),
        'date_naissance': date.trim(),
        'parente': parente.trim(),
      };
}

class Api {
  static const base = 'http://localhost/api-test/public';
  static const _h = {'Content-Type': 'application/json'};

  static Future<bool> auth(String path, String email, String pass) async {
    final r = await http.post(
      Uri.parse('$base/accounts/$path'),
      headers: _h,
      body: jsonEncode({'email': email.trim(), 'password': pass}),
    );
    return r.statusCode == 200 || r.statusCode == 201;
  }

  static Future<List<Membre>> liste() async {
    final r = await http.get(Uri.parse('$base/famille-membres'));
    final d = (jsonDecode(r.body)['data'] as List?) ?? [];
    return d.map((e) => Membre.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<void> save(Membre m) async {
    final uri = Uri.parse(
      m.id == 0 ? '$base/famille-membres' : '$base/famille-membres/${m.id}',
    );
    final body = jsonEncode(m.toJson());
    final r = m.id == 0
        ? await http.post(uri, headers: _h, body: body)
        : await http.put(uri, headers: _h, body: body);
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw Exception(jsonDecode(r.body)['message'] ?? 'Erreur');
    }
  }

  static Future<void> del(int id) async {
    final r = await http.delete(Uri.parse('$base/famille-membres/$id'));
    if (r.statusCode != 200 && r.statusCode != 204) throw Exception('Erreur');
  }
}
