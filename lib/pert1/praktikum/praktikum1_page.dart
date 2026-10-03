import 'package:flutter/material.dart';

class Praktikum1Page extends StatefulWidget {
  const Praktikum1Page({super.key});

  @override
  State<Praktikum1Page> createState() => _Praktikum1PageState();
}

class _Praktikum1PageState extends State<Praktikum1Page> {
  int _clickCount = 0;
  String _statusMessage = 'Aplikasi Pertama Berhasil Dimuat (onCreate)';

  void _onButtonClicked() {
    setState(() {
      _clickCount++;
      _statusMessage = 'Halo Zefhana Ananda! Tombol telah diklik $_clickCount kali.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_statusMessage),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 1 - Hello Android Studio'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(Icons.android, size: 64, color: Colors.green.shade600),
                    const SizedBox(height: 12),
                    const Text(
                      'Selamat Datang di Android Studio!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Aplikasi Pertama Praktikum Modul 1\nPemrograman Mobile (CR002)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF64748B), height: 1.4),
                    ),
                    const Divider(height: 32),
                    const Text(
                      'Nama: Zefhana Ananda',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Universitas Esa Unggul - Fakultas Ilmu Komputer',
                      style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _onButtonClicked,
                      icon: const Icon(Icons.touch_app),
                      label: const Text('Klik Saya!'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        _statusMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Struktur Project Android Studio (Modul 1):',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildItem('1. manifests (AndroidManifest.xml)', 'Mendefinisikan nama aplikasi, izin, dan activity utama.'),
                    _buildItem('2. java / kotlin', 'Tempat file kode logika pemrograman (MainActivity).'),
                    _buildItem('3. res / layout', 'File desain antarmuka pengguna berbasis XML (activity_main.xml).'),
                    _buildItem('4. res / values', 'File resource strings.xml, colors.xml, dan themes.xml.'),
                    _buildItem('5. Gradle Scripts', 'Mengatur dependensi pustaka dan konfigurasi build aplikasi.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueAccent)),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
        ],
      ),
    );
  }
}
