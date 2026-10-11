# Doc Tugas - Pertemuan 5: User Interface & Experience (Droid Cafe)

- **Nama Mahasiswa**: Zefhana Ananda
- **NIM**: 20240801047
- **Dosen Pengampu**: Jefry Sunupurwa Asri, S.Kom., M.Kom.
- **Mata Kuliah**: Pemrograman Mobile (CR002)
- **Fakultas**: Fakultas Ilmu Komputer, Universitas Esa Unggul

---

## Tangkapan Layar Hasil Running Aplikasi

### 1. Hasil Praktikum: Droid Cafe & Interactive Desserts
![Tampilan Praktikum Pertemuan 5](../../../screenshots/ss_pert5_praktikum.png)

### 2. Hasil Tugas: Order Activity & Delivery Options
![Tampilan Tugas Pertemuan 5](../../../screenshots/ss_pert5_tugas.png)

---

## BAB I: Pendahuluan & Tujuan Pembelajaran
1. Mempelajari prinsip dasar User Interface (UI) dan User Experience (UX) dalam pengembangan aplikasi mobile.
2. Mengimplementasikan elemen interaktif pada aplikasi (gambar dengan onClick listener dan widget radio button).
3. Menampilkan feedback langsung kepada pengguna menggunakan SnackBar / Toast message.
4. Mengimplementasikan AppBar Options Menu beserta item overflow menu (Order, Status, Favorites, Contact).
5. Membangun aplikasi pemesanan Droid Cafe dan formulir pengiriman pesanan (Order Activity).

---

## BAB II: Dasar Teori
Desain antarmuka pengguna (UI) berfokus pada estetika visual, tata letak, dan keterbacaan komponen, sedangkan pengalaman pengguna (UX) menekankan kemudahan, kenyamanan, dan alur interaksi pengguna saat menggunakan aplikasi.

Komponen utama yang dipelajari pada Modul 5 meliputi:
1. Interactive Images & Click Handling: Elemen visual seperti gambar dessert yang diberikan pendengar event sentuhan (onClick/onTap) sehingga dapat merespons aksi pengguna secara instan.
2. Options Menu & Overflow Menu: Menu utama pada AppBar/Toolbar yang menyediakan akses cepat ke fungsi penting aplikasi seperti Order, Status, Favorites, dan Contact.
3. Input Controls: Penggunaan komponen interaktif seperti RadioButton / RadioListTile untuk memilih satu opsi pengiriman dari beberapa pilihan, serta TextField untuk menginput data kontak dan alamat pemesan.
4. Feedback Komponen (SnackBar/Toast): Umpan balik visual sementara yang mengonfirmasi bahwa aksi pengguna (misalnya memilih menu dessert) telah berhasil diproses.

---

## BAB III: Pelaksanaan Praktikum (Droid Cafe & Interactive Desserts)
Pada praktikum Pertemuan 5, dibuat aplikasi Droid Cafe sesuai panduan modul. Layar menampilkan tiga jenis hidangan penutup (Donuts, Ice Cream Sandwiches, dan FroYo) lengkap dengan gambar, judul, dan deskripsi sesuai strings.xml. Saat pengguna mengklik salah satu hidangan, sistem memunculkan SnackBar pemberitahuan pesanan dan FloatingActionButton di pojok kanan bawah dapat ditekan untuk berpindah ke layar Order Activity. AppBar juga dilengkapi overflow menu dengan pilihan Order, Status, Favorites, dan Contact.

```dart
// lib/pert5/praktikum/praktikum5_page.dart
void _showOrderMessage(String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Lihat Order',
        textColor: Colors.amberAccent,
        onPressed: _openOrderActivity,
      ),
    ),
  );
}
```

---

## BAB IV: Pembahasan Tugas (Order Activity & Delivery Options)
Pada tugas Pertemuan 5, dibangun Order Activity yang menerima pesanan dessert dari layar sebelumnya. Halaman ini menyediakan formulir pengisian data pembeli (Nama, Alamat Pengiriman, Nomor Telepon, dan Catatan Tambahan) serta pilihan metode pengiriman menggunakan radio button: 'Same day messenger service', 'Next day ground delivery', atau 'Pick up'. Saat tombol konfirmasi ditekan, sistem melakukan validasi dan menampilkan ringkasan data pemesanan.

```dart
// lib/pert5/tugas/tugas5_page.dart
Widget _buildDeliveryRadio(String value, String title, String subtitle) {
  return RadioListTile<String>(
    value: value,
    groupValue: _deliveryMethod,
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    activeColor: const Color(0xFFD32F2F),
    onChanged: (val) {
      if (val != null) {
        setState(() => _deliveryMethod = val);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Metode: $title'), duration: const Duration(milliseconds: 900)),
        );
      }
    },
  );
}
```

---

## Tabel Sintaks & Widget Penting
| Syntax / Widget | Fungsi |
| :--- | :--- |
| `PopupMenuButton` | Widget untuk menampilkan overflow menu dropdown pada AppBar. |
| `PopupMenuItem` | Item pilihan tunggal di dalam PopupMenuButton. |
| `RadioListTile` | Widget gabungan tombol radio dengan label teks dan subtitle deskripsi. |
| `FloatingActionButton` | Tombol aksi melayang berbentuk lingkaran untuk aksi utama halaman. |
| `ScaffoldMessenger` | Manajer untuk menampilkan dan mengontrol SnackBar secara reaktif. |
| `TextEditingController` | Pengontrol nilai dan listener perubahan teks pada input form. |

---

## BAB V: Kesimpulan
1. Penerapan antarmuka yang ramah pengguna (UI/UX) sangat bergantung pada kejelasan visual dan umpan balik instan (feedback).
2. Options Menu dan Overflow Menu membantu menghemat ruang layar ponsel tanpa mengurangi kelengkapan fitur navigasi.
3. Kombinasi RadioButton dan formulir input memberikan kontrol data yang terstruktur dan meminimalkan kesalahan input pengguna.
