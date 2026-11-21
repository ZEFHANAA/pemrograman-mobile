import 'package:flutter/material.dart';

class KartuPerkenalanPage extends StatelessWidget {
  const KartuPerkenalanPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Tugas 1 · Kartu Perkenalan')),
        body: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const CircleAvatar(radius: 44, child: Icon(Icons.person, size: 48)),
                const SizedBox(height: 18),
                Text('Zefhana Ananda', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text('NIM: 20240801047'),
              const Text('Program Studi: sesuaikan dengan data pribadi'),
                const SizedBox(height: 8),
                const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.favorite, color: Colors.pink),
                  SizedBox(width: 8),
                Text('Hobi: sesuaikan dengan hobi kamu'),
                ]),
              ]),
            ),
          ),
        ),
      );
}
