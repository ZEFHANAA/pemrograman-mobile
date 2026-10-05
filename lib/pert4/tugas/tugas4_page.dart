import 'package:flutter/material.dart';

class Tugas4Page extends StatefulWidget {
  const Tugas4Page({super.key});

  @override
  State<Tugas4Page> createState() => _Tugas4PageState();
}

class _Tugas4PageState extends State<Tugas4Page> {
  final TextEditingController _urlController =
      TextEditingController(text: 'https://esaunggul.ac.id');
  final TextEditingController _locationController =
      TextEditingController(text: 'Universitas Esa Unggul, Jakarta');
  final TextEditingController _shareTextController =
      TextEditingController(text: 'Halo Dosen, tugas Pertemuan 4 sudah selesai!');

  @override
  void dispose() {
    _urlController.dispose();
    _locationController.dispose();
    _shareTextController.dispose();
    super.dispose();
  }

  void _simulateImplicitIntent(String title, String action, String data, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aksi Intent: $action',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                data,
                style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Pada sistem operasi Android asli, intent ini akan memicu Intent Chooser atau meluncurkan aplikasi eksternal (Browser/Maps/Share Sheet).',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas 4 - Implicit Intent'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Student Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Zefhana Ananda (20240801047)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tugas Pertemuan 4: Simulasi 3 Aksi Implicit Intent',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card 1: Open Website
            _buildIntentCard(
              title: '1. Intent Buka Website (ACTION_VIEW)',
              description: 'Membuka peramban (browser) untuk mengakses URL tertentu.',
              icon: Icons.language,
              iconColor: Colors.blue.shade700,
              controller: _urlController,
              label: 'Website URL',
              buttonText: 'OPEN WEBSITE',
              onPressed: () => _simulateImplicitIntent(
                'Open Website Intent',
                'Intent.ACTION_VIEW (Uri: http/https)',
                _urlController.text,
                Icons.language,
                Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 16),

            // Card 2: Open Location
            _buildIntentCard(
              title: '2. Intent Buka Lokasi (ACTION_VIEW geo)',
              description: 'Meluncurkan aplikasi peta (Maps) berdasarkan alamat lokasi.',
              icon: Icons.map,
              iconColor: Colors.green.shade700,
              controller: _locationController,
              label: 'Nama Lokasi / Alamat',
              buttonText: 'OPEN LOCATION',
              onPressed: () => _simulateImplicitIntent(
                'Open Location Intent',
                'Intent.ACTION_VIEW (Uri: geo:0,0?q=...)',
                'geo:0,0?q=${Uri.encodeComponent(_locationController.text)}',
                Icons.map,
                Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 16),

            // Card 3: Share Text
            _buildIntentCard(
              title: '3. Intent Bagikan Teks (ACTION_SEND)',
              description: 'Membuka dialog berbagi untuk mengirim pesan ke aplikasi lain.',
              icon: Icons.share,
              iconColor: Colors.orange.shade800,
              controller: _shareTextController,
              label: 'Pesan Teks yang Dibagikan',
              buttonText: 'SHARE TEXT',
              onPressed: () => _simulateImplicitIntent(
                'Share Text Intent',
                'Intent.ACTION_SEND (type: text/plain)',
                _shareTextController.text,
                Icons.share,
                Colors.orange.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntentCard({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required TextEditingController controller,
    required String label,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: iconColor.withOpacity(0.1),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, size: 18),
                label: Text(buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
