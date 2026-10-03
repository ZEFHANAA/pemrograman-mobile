import 'package:flutter/material.dart';

class Praktikum2Page extends StatelessWidget {
  const Praktikum2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello World',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Text(
                'Catatan Modul 2 (Halaman 10–15):\n'
                'Aplikasi ini dibuat menggunakan framework Flutter dengan komponen StatelessWidget MyApp & MyHomePage. '
                'Widget Scaffold digunakan untuk menyediakan struktur dasar Material Design seperti AppBar dan Body dengan widget Center.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF1E3A8A), height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
