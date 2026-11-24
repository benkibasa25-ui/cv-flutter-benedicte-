import 'package:flutter/material.dart';
import 'api_service.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    ));

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool isReg = false, busy = false;
  String msg = '';

  Future<void> go() async {
    setState(() {
      busy = true;
      msg = '';
    });
    final ok =
        await Api.auth(isReg ? 'register' : 'login', email.text, pass.text);
    if (!mounted) return;
    setState(() => busy = false);
    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FamilleScreen()),
      );
    } else {
      setState(() => msg = 'Identifiants invalides ou compte existant');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(isReg ? 'Inscription' : 'Connexion')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            TextField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: pass,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mot de passe')),
            const SizedBox(height: 12),
            if (msg.isNotEmpty)
              Text(msg, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
                onPressed: busy ? null : go,
                child: Text(isReg ? 'Créer' : 'Entrer')),
            TextButton(
                onPressed: () => setState(() => isReg = !isReg),
                child: Text(isReg ? 'Connexion' : 'Créer un compte')),
          ]),
        ),
      );
}

class FamilleScreen extends StatefulWidget {
  const FamilleScreen({super.key});
  @override
  State<FamilleScreen> createState() => _FamilleScreenState();
}

class _FamilleScreenState extends State<FamilleScreen> {
  List<Membre> items = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final data = await Api.liste();
    if (mounted) setState(() => items = data);
  }

  Future<void> form([Membre? m]) async {
    final cNom = TextEditingController(text: m?.nom ?? '');
    final cPost = TextEditingController(text: m?.postnom ?? '');
    final cPren = TextEditingController(text: m?.prenom ?? '');
    final cLieu = TextEditingController(text: m?.lieu ?? '');
    final cDate = TextEditingController(text: m?.date ?? '1995-01-01');
    final cPar = TextEditingController(text: m?.parente ?? '');

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(m == null ? 'Ajouter' : 'Modifier'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: cNom,
                decoration: const InputDecoration(labelText: 'Nom')),
            TextField(
                controller: cPost,
                decoration: const InputDecoration(labelText: 'Postnom')),
            TextField(
                controller: cPren,
                decoration: const InputDecoration(labelText: 'Prénom')),
            TextField(
                controller: cLieu,
                decoration: const InputDecoration(labelText: 'Lieu naissance')),
            TextField(
                controller: cDate,
                decoration:
                    const InputDecoration(labelText: 'Date (AAAA-MM-JJ)')),
            TextField(
                controller: cPar,
                decoration: const InputDecoration(labelText: 'Parenté')),
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              await Api.save(Membre(
                id: m?.id ?? 0,
                nom: cNom.text,
                postnom: cPost.text,
                prenom: cPren.text,
                lieu: cLieu.text,
                date: cDate.text,
                parente: cPar.text,
              ));
              if (ctx.mounted) Navigator.pop(ctx, true);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (ok == true) load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Famille'), actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: load),
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () => form(), child: const Icon(Icons.add)),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final x = items[i];
            return ListTile(
              title: Text('${x.nom} ${x.postnom} ${x.prenom}'),
              subtitle: Text('${x.parente} • ${x.lieu} (${x.date})'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    icon: const Icon(Icons.edit), onPressed: () => form(x)),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await Api.del(x.id);
                    load();
                  },
                ),
              ]),
            );
          },
        ),
      );
}
