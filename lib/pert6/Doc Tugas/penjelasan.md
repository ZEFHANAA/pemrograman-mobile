# Doc Tugas - Pertemuan 6: Material Design, Theme, & Scorekeeper

- **Nama Mahasiswa**: Zefhana Ananda
- **NIM**: 20240801047
- **Dosen Pengampu**: Jefry Sunupurwa Asri, S.Kom., M.Kom.
- **Mata Kuliah**: Pemrograman Mobile (CR002)
- **Fakultas**: Fakultas Ilmu Komputer, Universitas Esa Unggul

---

## Tangkapan Layar Hasil Running Aplikasi

### 1. Hasil Praktikum: Scorekeeper App & Day/Night Mode
![Tampilan Praktikum Pertemuan 6](../../../screenshots/ss_pert6_praktikum.png)

### 2. Hasil Tugas: Material Me Sports Card Catalog
![Tampilan Tugas Pertemuan 6](../../../screenshots/ss_pert6_tugas.png)

---

## BAB I: Pendahuluan & Tujuan Pembelajaran
1. Memahami prinsip Material Design dalam ekosistem aplikasi mobile modern.
2. Menerapkan tata letak pembagian bobot layar (layout_weight / Expanded) secara proporsional.
3. Mengimplementasikan dynamic theming: Day Mode (Light) dan Night Mode (Dark) pada aplikasi.
4. Mengembangkan aplikasi Scorekeeper untuk mencatat skor pertandingan dua tim secara interaktif.
5. Mengembangkan kartu olahraga (Material Me cards) dengan efek elevasi, visual menarik, dan navigasi terpadu.

---

## BAB II: Dasar Teori
Material Design adalah pedoman desain sistem buatan Google yang menggabungkan prinsip desain klasik dengan inovasi teknologi dan sains. Konsep utamanya berfokus pada materialitas fisik, pencahayaan, bayangan (elevation), dan tipografi yang konsisten.

Aspek teknis penting yang dipelajari pada Modul 6:
1. Layout Weight & Equal Proportion: Membagi area layar menjadi dua bagian seimbang (masing-masing 50% tinggi layar) menggunakan Expanded atau LinearLayout layout_weight='1', sehingga responsif di berbagai resolusi layar HP.
2. State Management Nilai Skor: Pengelolaan variabel status integer yang reaktif untuk menambah (increment) dan mengurangi (decrement) skor masing-masing tim secara independen tanpa error nilai negatif.
3. Day/Night Theme: Penerapan tema adaptif (Light & Dark theme) untuk kenyamanan mata pengguna dan penghematan daya baterai.
4. Card Elevation & Material Surface: Penggunaan widget Card dengan bayangan elevasi untuk menyajikan informasi ringkas olahraga.

---

## BAB III: Pelaksanaan Praktikum (Scorekeeper App & Day/Night Mode)
Pada praktikum Pertemuan 6, diimplementasikan aplikasi Scorekeeper (Pencatat Skor) untuk Team 1 dan Team 2. Layar dibagi rata menjadi dua panel utama menggunakan Expanded. Masing-masing panel tim memiliki label nama tim, tampilan angka skor besar, serta dua tombol bundar: tombol plus (+) untuk menambah skor dan tombol minus (-) untuk mengurangi skor dengan batasan minimum 0. AppBar dilengkapi tombol aksi untuk mengganti tema Day/Night mode secara instan serta tombol reset skor.

```dart
// lib/pert6/praktikum/praktikum6_page.dart
void _increaseScore(int team) {
  setState(() {
    if (team == 1) _score1++;
    else _score2++;
  });
}

void _decreaseScore(int team) {
  setState(() {
    if (team == 1 && _score1 > 0) _score1--;
    if (team == 2 && _score2 > 0) _score2--;
  });
}
```

---

## BAB IV: Pembahasan Tugas (Material Me Sports Card Catalog)
Pada tugas Pertemuan 6, dikembangkan aplikasi katalog olahraga 'Material Me' yang mengimplementasikan Card Material Design. Daftar olahraga mencakup Badminton, Basketball, Bowling, dan Soccer. Setiap kartu olahraga dilengkapi banner ikon grafis, judul olahraga, cuplikan berita singkat, dan indikator pertandingan. Menekan tombol 'Buka Papan Skor' pada setiap kartu akan mengarahkan pengguna langsung ke aplikasi Scorekeeper untuk mencatat jalannya pertandingan.

```dart
// lib/pert6/tugas/tugas6_page.dart
Widget _buildSportCard(Map<String, dynamic> sport) {
  return Card(
    elevation: 3,
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Column(
      children: [
        ListTile(
          title: Text(sport['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(sport['subtitle'] as String),
          trailing: ElevatedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Praktikum6Page())),
            icon: const Icon(Icons.scoreboard, size: 16),
            label: const Text('Skor'),
          ),
        ),
      ],
    ),
  );
}
```

---

## Tabel Sintaks & Widget Penting
| Syntax / Widget | Fungsi |
| :--- | :--- |
| `ThemeData` | Konfigurasi skema warna, kecerahan (brightness), dan gaya visual seluruh aplikasi. |
| `Brightness.dark` | Mode tema gelap (Night Mode) untuk kenyamanan visual di lingkungan minim cahaya. |
| `Expanded` | Widget untuk mengisi ruang kosong yang tersedia secara proporsional sesuai rasio flex. |
| `IconButton` | Tombol berupa ikon Material dengan efek splash saat disentuh. |
| `Card` | Permukaan Material berbentuk kotak bersudut melengkung dengan bayangan elevasi. |
| `Navigator.push` | Metode transisi navigasi menuju halaman atau rute baru di tumpukan layar. |

---

## BAB V: Kesimpulan
1. Penerapan Material Design memberikan tampilan aplikasi yang konsisten, modern, dan nyaman digunakan pengguna.
2. Fitur Day/Night mode meningkatkan aksesibilitas dan kepuasan pengguna di berbagai kondisi pencahayaan.
3. Komponen Scorekeeper dan Material Cards mendemonstrasikan integrasi manajemen state interaktif dan estetika visual yang seimbang.
