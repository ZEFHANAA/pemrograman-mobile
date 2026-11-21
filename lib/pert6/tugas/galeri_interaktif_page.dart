import 'package:flutter/material.dart';

class CatalogEntry {
  const CatalogEntry({required this.title, required this.category, required this.description, required this.icon, required this.color});
  final String title;
  final String category;
  final String description;
  final IconData icon;
  final Color color;
}

const _entries = <CatalogEntry>[
  CatalogEntry(title: 'Flutter', category: 'Framework', description: 'Toolkit UI lintas platform untuk membuat aplikasi dari satu basis kode.', icon: Icons.flutter_dash, color: Colors.blue),
  CatalogEntry(title: 'Dart', category: 'Bahasa', description: 'Bahasa pemrograman yang digunakan untuk membangun aplikasi Flutter.', icon: Icons.code, color: Colors.indigo),
  CatalogEntry(title: 'Material Design', category: 'Desain', description: 'Sistem komponen dan pola desain untuk antarmuka aplikasi.', icon: Icons.palette, color: Colors.deepPurple),
  CatalogEntry(title: 'Navigator', category: 'Navigasi', description: 'Mengelola perpindahan halaman dan tumpukan route aplikasi.', icon: Icons.alt_route, color: Colors.teal),
];

class GaleriInteraktifPage extends StatelessWidget {
  const GaleriInteraktifPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Tugas 6 · Katalog Flutter')),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .9),
          itemCount: _entries.length,
          itemBuilder: (context, index) {
            final entry = _entries[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => Navigator.push<void>(context, MaterialPageRoute<void>(builder: (_) => _CatalogDetailPage(entry: entry))),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: Center(child: Hero(tag: 'catalog-${entry.title}', child: Icon(entry.icon, size: 64, color: entry.color))),
                    ),
                    Text(entry.category, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: entry.color)),
                    const SizedBox(height: 4),
                    Text(entry.title, style: Theme.of(context).textTheme.titleMedium),
                  ]),
                ),
              ),
            );
          },
        ),
      );
}

class _CatalogDetailPage extends StatelessWidget {
  const _CatalogDetailPage({required this.entry});
  final CatalogEntry entry;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(entry.title)),
        body: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: entry.color.withValues(alpha: .12), borderRadius: BorderRadius.circular(24)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Hero(tag: 'catalog-${entry.title}', child: Icon(entry.icon, size: 92, color: entry.color)),
              const SizedBox(height: 20),
              Text(entry.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(entry.description, textAlign: TextAlign.center),
            ]),
          ),
        ),
      );
}
