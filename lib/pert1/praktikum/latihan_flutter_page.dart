import 'package:flutter/material.dart';

class LatihanFlutterPage extends StatefulWidget {
  const LatihanFlutterPage({super.key});

  @override
  State<LatihanFlutterPage> createState() => _LatihanFlutterPageState();
}

class _LatihanFlutterPageState extends State<LatihanFlutterPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Praktikum 1 · Flutter Pertamaku')),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.flutter_dash, size: 76, color: Colors.blue),
            const SizedBox(height: 12),
            Text('Halo, Zefhana!', style: Theme.of(context).textTheme.headlineSmall),
            const Text('NIM: 20240801047'),
            const SizedBox(height: 28),
            const Text('Counter StatefulWidget', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('$_counter', style: Theme.of(context).textTheme.displayMedium),
            Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton.filledTonal(onPressed: _counter > 0 ? () => setState(() => _counter--) : null, icon: const Icon(Icons.remove)),
              const SizedBox(width: 12),
              FilledButton.icon(onPressed: () => setState(() => _counter++), icon: const Icon(Icons.add), label: const Text('Tambah')),
              const SizedBox(width: 12),
              TextButton(onPressed: () => setState(() => _counter = 0), child: const Text('Reset')),
            ]),
          ]),
        ),
      );
}
