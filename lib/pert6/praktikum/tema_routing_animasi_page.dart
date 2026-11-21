import 'package:flutter/material.dart';

import '../../app_theme_controller.dart';

class TemaRoutingAnimasiPage extends StatelessWidget {
  const TemaRoutingAnimasiPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Praktikum 6 · Theme & Navigasi'),
          actions: [
            ValueListenableBuilder<ThemeMode>(
              valueListenable: AppThemeController.mode,
              builder: (context, mode, _) => IconButton(
                tooltip: mode == ThemeMode.light ? 'Aktifkan mode gelap' : 'Aktifkan mode terang',
                onPressed: AppThemeController.toggle,
                icon: Icon(mode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
              ),
            ),
          ],
        ),
        body: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.palette_outlined, size: 56),
                const SizedBox(height: 12),
                Text('Tema aktif mengikuti pilihan di AppBar.', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                const Text('Pilih ikon matahari/bulan. Tema seluruh aplikasi ikut berubah.'),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => Navigator.push<void>(context, MaterialPageRoute<void>(builder: (_) => const _NavigationDemoPage())),
                  icon: const Icon(Icons.route),
                  label: const Text('Coba navigasi'),
                ),
              ]),
            ),
          ),
        ),
      );
}

class _NavigationDemoPage extends StatelessWidget {
  const _NavigationDemoPage();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Halaman Navigasi')),
        body: const Center(child: Text('Halaman kedua. Gunakan tombol kembali untuk kembali ke praktikum.')),
      );
}
