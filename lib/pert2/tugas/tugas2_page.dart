import 'package:flutter/material.dart';

class Tugas2Page extends StatefulWidget {
  const Tugas2Page({super.key});

  @override
  State<Tugas2Page> createState() => _Tugas2PageState();
}

class _Tugas2PageState extends State<Tugas2Page> {
  int _counter = 0;
  bool _isFavorite = false;

  void _increment() => setState(() => _counter++);
  void _decrement() {
    if (_counter > 0) setState(() => _counter--);
  }
  void _reset() => setState(() => _counter = 0);
  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Menyukai materi Flutter!' : 'Batal menyukai materi'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas 2 - Profil & Counter Interaktif'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Student Profile Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.indigo.shade100,
                      child: const Icon(Icons.person, size: 40, color: Colors.indigo),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Zefhana Ananda',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Mahasiswa Pemrograman Mobile (CR002)',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                    const Divider(height: 24),
                    _buildRow(Icons.school, 'Institusi', 'Universitas Esa Unggul'),
                    const SizedBox(height: 6),
                    _buildRow(Icons.menu_book, 'Mata Kuliah', 'Pemrograman Mobile (CR002)'),
                    const SizedBox(height: 6),
                    _buildRow(Icons.person_pin, 'Dosen', 'Jefry Sunupurwa Asri, S.Kom., M.Kom.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Concept Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.layers, color: Colors.indigo.shade700),
                        const SizedBox(width: 8),
                        const Text(
                          'Arsitektur Framework Flutter:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Framework (Dart): Material & Cupertino widgets, rendering tree, animation.\n'
                      '2. Engine (C++): Skia/Impeller grafis, Dart VM, Text layout engine.\n'
                      '3. Embedder: Menghubungkan ke sistem operasi target (Android, iOS, Web, Desktop).',
                      style: TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Interactive State Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Demonstrasi State Management (StatefulWidget)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Nilai di bawah ini diperbarui secara reaktif menggunakan setState():',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.indigo.shade200),
                      ),
                      child: Text(
                        '$_counter',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          onPressed: _decrement,
                          icon: const Icon(Icons.remove),
                          tooltip: 'Kurangi',
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _increment,
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: _reset,
                          child: const Text('Reset'),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _toggleFavorite,
                          icon: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey,
                          ),
                          tooltip: 'Favorit',
                        ),
                      ],
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

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.indigo),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
        Expanded(child: Text(value, style: const TextStyle(color: Color(0xFF475569), fontSize: 12.5))),
      ],
    );
  }
}
