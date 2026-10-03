import 'package:flutter/material.dart';

class Praktikum3Page extends StatelessWidget {
  const Praktikum3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Praktikum 3 - Model Layout'),
          backgroundColor: Colors.teal.shade800,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: '1. LinearLayout'),
              Tab(text: '2. RelativeLayout'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LinearLayoutDemo(),
            _RelativeLayoutDemo(),
          ],
        ),
      ),
    );
  }
}

class _LinearLayoutDemo extends StatelessWidget {
  const _LinearLayoutDemo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Implementasi Modul 3 (Hal 8-10): Form Kirim Pesan LinearLayout secara vertikal. Field Message menggunakan flex/weight 1 untuk mengambil sisa tinggi layar.',
              style: TextStyle(fontSize: 12, color: Color(0xFF0F766E)),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'To',
              hintText: 'Tujuan penerima pesan',
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Subject',
              hintText: 'Subjek pesan',
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          const Expanded(
            child: TextField(
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Tulis pesan Anda di sini...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pesan terkirim via LinearLayout!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                ),
                child: const Text('SEND'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RelativeLayoutDemo extends StatelessWidget {
  const _RelativeLayoutDemo();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Implementasi Modul 3 (Hal 12-14): Form Registrasi RelativeLayout. Elemen Name berada di bawah Registration dan di sebelah kiri Gender; tombol DONE berada di bawah Gender dan sejajar kanan.',
              style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
            ),
          ),
          const SizedBox(height: 20),
          // Form Box simulating RelativeLayout
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Registration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  const Divider(height: 16),
                  const SizedBox(height: 8),
                  // Row with Name (Expanded left) and Gender (96dp right)
                  Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 100,
                        child: DropdownButtonFormField<String>(
                          value: 'Male',
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: UnderlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Male', child: Text('Male')),
                            DropdownMenuItem(value: 'Female', child: Text('Female')),
                          ],
                          onChanged: (val) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // DONE Button aligned right
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Data registrasi disimpan!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('DONE'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
