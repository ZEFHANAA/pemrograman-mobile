import 'package:flutter/material.dart';
import 'app_theme_controller.dart';

import 'pert1/praktikum/latihan_flutter_page.dart';
import 'pert1/tugas/kartu_perkenalan_page.dart';
import 'pert2/praktikum/daftar_kontak_page.dart';
import 'pert2/tugas/cari_kontak_page.dart';
import 'pert3/praktikum/form_provider_page.dart';
import 'pert3/tugas/daftar_belanja_page.dart';
import 'pert4/praktikum/pengguna_api_page.dart';
import 'pert4/tugas/postingan_page.dart';
import 'pert5/praktikum/penyimpanan_page.dart';
import 'pert5/tugas/pencatat_pengeluaran_page.dart';
import 'pert6/praktikum/tema_routing_animasi_page.dart';
import 'pert6/tugas/galeri_interaktif_page.dart';
import 'pert7/pages/aktivitas_form_page.dart';
import 'pert7/pages/tabungku_shell_page.dart';
import 'pert7/models/aktivitas_tabungan.dart';
import 'pert8/pages/status_server_page.dart';
import 'pert8/praktikum/status_server_praktikum_page.dart';
import 'pert8/tugas/status_server_tugas_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppThemeController.load();
  runApp(const PemmobApp());
}

class PemmobApp extends StatelessWidget {
  const PemmobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: AppThemeController.seed,
      builder: (context, seed, _) => ValueListenableBuilder<ThemeMode>(
        valueListenable: AppThemeController.mode,
        builder: (context, mode, _) => MaterialApp(
      title: 'PEMMOB - Zefhana Ananda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seed,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seed,
        brightness: Brightness.dark,
      ),
      themeMode: mode,
      onGenerateRoute: (settings) {
        if (settings.name == '/tabungku/form') {
          final argument = settings.arguments;
          return MaterialPageRoute<void>(
            builder: (_) => AktivitasTabunganFormPage(kegiatan: argument is AktivitasTabungan ? argument : null),
          );
        }
        if (settings.name == '/status') {
          return MaterialPageRoute<void>(builder: (_) => const StatusServerPage());
        }
        return null;
      },
      home: const MainDashboard(),
        ),
      ),
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
                'Praktikum & Tugas Pertemuan 1–8',
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
            subtitle: 'Pengenalan Flutter, widget, dan aplikasi pertama',
              color: Colors.blue.shade700,
              icon: Icons.android,
            praktikumTitle: 'Praktikum 1: Hello Flutter & Counter',
            praktikumDesc: 'Widget dasar, hot reload, StatefulWidget, dan setState',
              onPraktikumTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LatihanFlutterPage()));
              },
            tugasTitle: 'Tugas 1: Kartu Perkenalan',
            tugasDesc: 'Menampilkan foto/ikon, nama, NIM, program studi, dan hobi',
              onTugasTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const KartuPerkenalanPage()));
              },
            ),
            const SizedBox(height: 20),

            // Section Pertemuan 2
            _buildMeetingSection(
              title: 'Pertemuan 2',
            subtitle: 'Layout, ListView, dan navigasi',
              color: Colors.purple.shade700,
              icon: Icons.flutter_dash,
            praktikumTitle: 'Praktikum 2: ListView & Navigasi Kontak',
            praktikumDesc: 'Daftar kontak dan halaman detail dengan Navigator.push',
              onPraktikumTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DaftarKontakPage()));
              },
            tugasTitle: 'Tugas 2: Daftar Kontak',
            tugasDesc: 'Pencarian kontak, ListView, dan halaman detail',
              onTugasTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CariKontakPage()));
              },
            ),
            const SizedBox(height: 20),

            // Section Pertemuan 3
            _buildMeetingSection(
              title: 'Pertemuan 3',
            subtitle: 'Form, validasi, Provider & daftar belanja',
              color: Colors.teal.shade700,
              icon: Icons.view_quilt,
            praktikumTitle: 'Praktikum 3: Form & Provider',
            praktikumDesc: 'Validasi input barang dan pembaruan daftar melalui ChangeNotifier',
              onPraktikumTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FormProviderPage()));
              },
            tugasTitle: 'Tugas 3: Daftar Belanja',
            tugasDesc: 'Tambah barang, tandai sudah dibeli, dan hapus dengan Provider',
              onTugasTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DaftarBelanjaPage()));
              },
            ),
            const SizedBox(height: 20),

            // Section Pertemuan 4
            _buildMeetingSection(
              title: 'Pertemuan 4',
          subtitle: 'REST API dan pemuatan data asinkron',
              color: Colors.deepPurple.shade700,
              icon: Icons.swap_horiz,
            praktikumTitle: 'Praktikum 4: FutureBuilder & REST API',
            praktikumDesc: 'Memuat JSONPlaceholder dengan status loading, error, dan coba lagi',
              onPraktikumTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PenggunaApiPage()));
              },
            tugasTitle: 'Tugas 4: Daftar Postingan & Komentar',
            tugasDesc: 'REST API, model fromJson, FutureBuilder, dan halaman detail',
              onTugasTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DaftarPostinganPage()));
              },
            ),
            const SizedBox(height: 20),

            // Section Pertemuan 5
            _buildMeetingSection(
              title: 'Pertemuan 5',
            subtitle: 'Penyimpanan data lokal: Shared Preferences & SQLite',
              color: const Color(0xFFD81B60),
          icon: Icons.receipt_long,
            praktikumTitle: 'Praktikum 5: CRUD Pengeluaran dengan SQLite',
            praktikumDesc: 'Tambah, baca, ubah, dan hapus data lokal; pengaturan disimpan di preferences',
              onPraktikumTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PenyimpananPage()));
              },
            tugasTitle: 'Tugas 5: Aplikasi Catatan Pengeluaran',
            tugasDesc: 'CRUD SQLite dengan pengaturan mata uang Shared Preferences',
              onTugasTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PencatatPengeluaranPage()));
              },
            ),
            const SizedBox(height: 20),

            // Section Pertemuan 6
            _buildMeetingSection(
              title: 'Pertemuan 6',
            subtitle: 'Tema, routing, navigasi, animasi, dan katalog',
              color: Colors.teal.shade800,
          icon: Icons.auto_awesome_motion,
            praktikumTitle: 'Praktikum 6: ThemeMode & Navigasi',
            praktikumDesc: 'Mengganti tema global dan berpindah halaman',
              onPraktikumTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TemaRoutingAnimasiPage()));
              },
            tugasTitle: 'Tugas 6: Katalog Flutter',
            tugasDesc: 'Galeri kartu, detail item, Hero, dan animasi transisi',
              onTugasTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GaleriInteraktifPage()));
              },
            ),
            const SizedBox(height: 20),

            // Section Pertemuan 7
            _buildMeetingSection(
              title: 'Pertemuan 7',
            subtitle: 'Mini proyek terpadu TabungKu',
              color: const Color(0xFF1565C0),
          icon: Icons.savings,
            praktikumTitle: 'Praktikum 7: TabungKu',
            praktikumDesc: 'To-do kegiatan, SQLite, laporan tabungan, tema, dan navigasi',
              onPraktikumTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Praktikum7Page()));
              },
            tugasTitle: 'Tugas 7: Mini Proyek TabungKu',
            tugasDesc: 'Manajemen kegiatan dan pemasukan/pengeluaran dengan laporan harian',
              onTugasTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Tugas7Page()));
              },
            ),
            const SizedBox(height: 20),

            // Section Pertemuan 8
            _buildMeetingSection(
              title: 'Pertemuan 8',
            subtitle: 'Docker Compose, MySQL, FastAPI, dan Flutter',
              color: const Color(0xFFE65100),
          icon: Icons.cloud_done,
            praktikumTitle: 'Praktikum 8: FastAPI & Health Check',
            praktikumDesc: 'Memeriksa API dan koneksi MySQL dari aplikasi Flutter',
              onPraktikumTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const StatusServerPraktikumPage()));
              },
            tugasTitle: 'Tugas 8: Adminer & Status TabungKu Cloud',
            tugasDesc: 'Docker Compose, health check MySQL, dan konfigurasi alamat API tersimpan',
              onTugasTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const StatusServerTugasPage()));
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
