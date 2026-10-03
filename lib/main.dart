import 'package:flutter/material.dart';

import 'pert1/Praktikum/praktikum1_page.dart';
import 'pert1/Tugas/tugas1_page.dart';
import 'pert2/Praktikum/hello_app_page.dart';
import 'pert2/Tugas/tugas2_page.dart';
import 'pert3/Praktikum/praktikum3_page.dart';
import 'pert3/Tugas/tugas3_page.dart';

void main() {
  runApp(const PemmobApp());
}

class PemmobApp extends StatelessWidget {
  const PemmobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PEMMOB - Zefhana Ananda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pemrograman Mobile (CR002)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Student Profile Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade800, Colors.indigo.shade600],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.person, size: 45, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Zefhana Ananda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'NIM: 20240801047',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Fakultas Ilmu Komputer - Universitas Esa Unggul',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Tugas & Praktikum Modul 1 - 2 - 3',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Pertemuan 1
            _buildMeetingSection(
              title: 'Pertemuan 1',
              subtitle: 'Pengenalan Konsep Dasar Android & Tools',
              color: Colors.blue.shade700,
              icon: Icons.android,
              praktikumTitle: 'Praktikum 1: Hello Android Studio',
              praktikumDesc: 'Pengenalan struktur folder manifests, java, res, & lifecycle',
              onPraktikumTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Praktikum1Page()));
              },
              tugasTitle: 'Tugas 1: Eksplorasi 4 Lapisan Arsitektur Android',
              tugasDesc: 'Linux Kernel, Native Libraries & ART, Framework, Applications',
              onTugasTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Tugas1Page()));
              },
            ),
            const SizedBox(height: 20),

            // Section Pertemuan 2
            _buildMeetingSection(
              title: 'Pertemuan 2',
              subtitle: 'Konsep Dasar Arsitektur & Pemrograman Flutter',
              color: Colors.purple.shade700,
              icon: Icons.flutter_dash,
              praktikumTitle: 'Praktikum 2: Hello World Flutter (hello_app)',
              praktikumDesc: 'Sesuai Modul 2 Halaman 10–15 (StatelessWidget & Scaffold)',
              onPraktikumTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Praktikum2Page()));
              },
              tugasTitle: 'Tugas 2: Profil & Counter Reaktif StatefulWidget',
              tugasDesc: 'State management lokal menggunakan setState() & SnackBar',
              onTugasTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Tugas2Page()));
              },
            ),
            const SizedBox(height: 20),

            // Section Pertemuan 3
            _buildMeetingSection(
              title: 'Pertemuan 3',
              subtitle: 'Perancangan Model Layout pada Android & Flutter',
              color: Colors.teal.shade700,
              icon: Icons.view_quilt,
              praktikumTitle: 'Praktikum 3: LinearLayout & RelativeLayout',
              praktikumDesc: 'Form Kirim Pesan (weights) & Form Registrasi (posisi relatif)',
              onPraktikumTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Praktikum3Page()));
              },
              tugasTitle: 'Tugas 3: Form Pendaftaran Mahasiswa Komprehensif',
              tugasDesc: 'Formulir lengkap dengan validasi input & dialog konfirmasi',
              onTugasTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Tugas3Page()));
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingSection({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required String praktikumTitle,
    required String praktikumDesc,
    required VoidCallback onPraktikumTap,
    required String tugasTitle,
    required String tugasDesc,
    required VoidCallback onTugasTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Praktikum Tile
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.code, color: Colors.green.shade700, size: 22),
              ),
              title: Text(
                praktikumTitle,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                praktikumDesc,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: onPraktikumTap,
            ),
            const SizedBox(height: 4),
            // Tugas Tile
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.assignment, color: Colors.amber.shade800, size: 22),
              ),
              title: Text(
                tugasTitle,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                tugasDesc,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: onTugasTap,
            ),
          ],
        ),
      ),
    );
  }
}
