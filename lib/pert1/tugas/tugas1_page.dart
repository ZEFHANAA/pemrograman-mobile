import 'package:flutter/material.dart';

class Tugas1Page extends StatefulWidget {
  const Tugas1Page({super.key});

  @override
  State<Tugas1Page> createState() => _Tugas1PageState();
}

class _Tugas1PageState extends State<Tugas1Page> {
  int _selectedLayer = 0;

  final List<Map<String, dynamic>> _layers = [
    {
      'title': '1. Linux Kernel (Lapisan Terbawah)',
      'color': Colors.green,
      'icon': Icons.memory,
      'summary': 'Jantung dari seluruh sistem operasi Android yang berhubungan dengan hardware.',
      'details': [
        'Abstraksi Hardware: Menjembatani komponen fisik (kamera, layar sentuh, bluetooth, Wi-Fi, audio) dengan software.',
        'Manajemen Memori: Mengontrol alokasi RAM secara optimal untuk berbagai proses.',
        'Manajemen Proses: Mengatur penjadwalan eksekusi thread dan CPU.',
        'Power Management: Efisiensi konsumsi daya baterai perangkat bergerak.',
        'Sistem Keamanan: Memberikan isolasi (sandboxing) hak akses antar aplikasi.'
      ]
    },
    {
      'title': '2. Native Libraries & Android Runtime (ART/Dalvik)',
      'color': Colors.blue,
      'icon': Icons.build_circle,
      'summary': 'Kumpulan pustaka C/C++ performa tinggi dan mesin virtual eksekusi bytecode DEX.',
      'details': [
        'Surface Manager: Mengelola komposit render tampilan jendela aplikasi ke layar.',
        'SGL & OpenGL ES: Rendering grafis 2D dan 3D tingkat lanjut.',
        'Media Framework: Menangani codec format audio dan video (MP4, MP3, AAC, JPEG).',
        'WebKit / Blink: Mesin rendering peramban web modern.',
        'FreeType: Rendering font teks bitmap dan vektor.',
        'Android Runtime (ART/Dalvik VM): Virtual machine berbasis register yang hemat memori untuk menjalankan aplikasi Android secara terisolasi.'
      ]
    },
    {
      'title': '3. Application Framework',
      'color': Colors.orange,
      'icon': Icons.widgets,
      'summary': 'Blok pembangun API tingkat tinggi yang digunakan developer untuk membuat aplikasi.',
      'details': [
        'Activity Manager: Mengontrol seluruh daur hidup (lifecycle) aktivitas dan tumpukan navigasi (backstack).',
        'Content Providers: Mekanisme berbagi data yang aman antar aplikasi (misal daftar kontak, galeri).',
        'Resource Manager: Mengelola berkas non-kode (layout XML, string lokal, aset gambar).',
        'Notification Manager: Menampilkan pesan peringatan atau pemberitahuan pada status bar.',
        'View System: Kumpulan komponen antarmuka standar seperti Button, TextView, EditText, dan ListView.'
      ]
    },
    {
      'title': '4. Applications Layer (Lapisan Terluar)',
      'color': Colors.pink,
      'icon': Icons.apps,
      'summary': 'Lapisan aplikasi yang berinteraksi langsung dengan pengguna akhir (end-user).',
      'details': [
        'Aplikasi Sistem Bawaan: Phone dialer, SMS/Pesan, Web Browser, Jam, Kalender, Kamera.',
        'Aplikasi Pihak Ketiga (Third-Party): Seluruh aplikasi yang dikembangkan dan diunduh oleh pengguna (contoh: WhatsApp, YouTube, aplikasi buatan mahasiswa ini).'
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    final active = _layers[_selectedLayer];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas 1 - Arsitektur Android'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade700, Colors.indigo.shade900],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Arsitektur Sistem Operasi Android',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tugas Pertemuan 1 - Zefhana Ananda (CR002)',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pilih salah satu lapisan di bawah untuk mempelajari rincian fungsi teknisnya sesuai Modul 1:',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_layers.length, (idx) {
                final isSelected = _selectedLayer == idx;
                final l = _layers[idx];
                return ChoiceChip(
                  label: Text('Layer ${idx + 1}'),
                  selected: isSelected,
                  selectedColor: l['color'],
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedLayer = idx);
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: (active['color'] as MaterialColor).shade100,
                          child: Icon(active['icon'], color: active['color']),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            active['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: active['color'],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      active['summary'],
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF475569),
                        fontSize: 13,
                      ),
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Fungsi-Fungsi Komponen Utama:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    ...(active['details'] as List<String>).map(
                      (d) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(d, style: const TextStyle(fontSize: 13, height: 1.4)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
