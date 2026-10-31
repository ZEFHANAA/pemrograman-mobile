import 'package:flutter/material.dart';

import '../theme/splw_theme.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Koneksi Bermasalah')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: SplwTheme.softPrimaryOf(context),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 52,
                  color: SplwTheme.primaryTeal,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Server tidak merespons',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Periksa koneksi internet Anda, lalu coba lagi. Fitur yang sudah dimuat tetap dapat digunakan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                key: const Key('network_retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SplwTheme.primaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text(
                  'Coba Lagi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
