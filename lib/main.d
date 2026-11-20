import 'package:flutter/material.dart';

void main() {
  runApp(const MonCvApp());
}

class MonCvApp extends StatelessWidget {
  const MonCvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV - Bénédicte Kibasa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CvHomePage(),
    );
  }
}

class CvHomePage extends StatelessWidget {
  const CvHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV — Bénédicte Kibasa'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 52,
                    child: Icon(Icons.person, size: 52),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Bénédicte Kibasa',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Informatique appliquée à la gestion des entreprises',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Goma, République Démocratique du Congo',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _SectionCard(
              title: 'À propos',
              content:
                  'Étudiante motivée en informatique appliquée à la gestion des entreprises, '
                  'intéressée par le développement logiciel, la gestion de données, '
                  'les systèmes d’information et les projets à impact.',
            ),
            const SizedBox(height: 14),
            const _SectionCard(
              title: 'Formation',
              content:
                  '• Licence en Informatique appliquée à la gestion des entreprises — ISIG-Goma\n'
                  '• Projets académiques : bases de données, développement web et applicatif, modélisation.',
            ),
            const SizedBox(height: 14),
            const _SectionCard(
              title: 'Compétences',
              content:
                  '• Développement & Web : Flutter / Dart, HTML, PHP, C#\n'
                  '• Bases de données & Modélisation : MySQL, modélisation UML\n'
                  '• Bureautique & Outils : Traitement de texte, travail collaboratif, Git / GitHub',
            ),
            const SizedBox(height: 14),
            const _SectionCard(
              title: 'Contact',
              content:
                  '• Ville : Goma, RD Congo\n'
                  '• GitHub : benkibasa25-ui',
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String content;

  const _SectionCard({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
