# Doc Tugas - Pertemuan 7: Location Based Service (LBS)

- **Nama Mahasiswa**: Zefhana Ananda
- **NIM**: 20240801047
- **Dosen Pengampu**: Jefry Sunupurwa Asri, S.Kom., M.Kom.
- **Mata Kuliah**: Pemrograman Mobile (CR002)
- **Fakultas**: Fakultas Ilmu Komputer, Universitas Esa Unggul

---

## BAB I: Pendahuluan & Tujuan Pembelajaran
1. Memahami konsep Location Based Service (LBS) dan komponen utamanya pada aplikasi mobile.
2. Menguasai peran **Location Provider** (API Location) dalam membaca koordinat lintang (*latitude*) dan bujur (*longitude*) perangkat melalui GPS satelit.
3. Menguasai peran **Location Manager** (API Maps) dalam menampilkan peta, menempatkan penanda (*marker*), jendela informasi (*info window*), serta mengontrol sudut kamera (*camera update*).
4. Memahami konfigurasi keamanan Google Maps API Key pada manifest proyek Android (`AndroidManifest.xml`).
5. Mengembangkan aplikasi **PetaWisata Indonesia** yang mengintegrasikan penentuan posisi pengguna, filter kategori, pencarian destinasi, dan kalkulasi jarak dinamis menggunakan formula *Haversine*.

---

## BAB II: Dasar Teori

### 2.1 Konsep Location Based Service (LBS)
LBS adalah layanan informasi yang menggabungkan tiga pilar teknologi:
1. **Geographic Information System (GIS)**: Pemodelan data geografis permukaan bumi.
2. **Internet Service**: Jaringan transmisi data untuk sinkronisasi konten real-time.
3. **Mobile Devices**: Perangkat genggam yang dilengkapi sensor penentu posisi (GPS receiver & cell network).

### 2.2 Dua Unsur Utama LBS
- **Location Manager (API Maps)**: Berfungsi menampilkan, memanipulasi, dan merender tampilan peta (tampilan normal vector, satelit, atau terrain), mengarahkan titik kamera, dan menampilkan penanda lokasi.
- **Location Provider (API Location)**: Berfungsi menyediakan koordinat geografis posisi perangkat pengguna saat ini secara real-time melalui GPS, jaringan seluler (BTS), maupun Wi-Fi.

### 2.3 Formula Haversine (Perhitungan Jarak Geografis)
Untuk menghitung jarak garis lurus antara posisi pengguna $(lat_1, lng_1)$ dengan koordinat destinasi wisata $(lat_2, lng_2)$ dengan memperhitungkan kelengkungan bumi, digunakan rumus Haversine:

$$a = \sin^2\left(\frac{\Delta\text{lat}}{2}\right) + \cos(\text{lat}_1) \cdot \cos(\text{lat}_2) \cdot \sin^2\left(\frac{\Delta\text{lng}}{2}\right)$$
$$c = 2 \cdot \text{atan2}\left(\sqrt{a}, \sqrt{1-a}\right)$$
$$\text{Jarak} = R \cdot c \quad (\text{dengan } R = 6.371 \text{ km})$$

---

## BAB III: Pelaksanaan Praktikum (Location Provider & Status GPS)

Pada praktikum Pertemuan 7, diimplementasikan aplikasi pembacaan koordinat perangkat secara langsung. Halaman praktikum menampilkan:
1. **Banner Panduan**: Menjelaskan konsep kerja Location Provider & Location Manager.
2. **Card Status Lokasi**: Menampilkan koordinat *Latitude* dan *Longitude* berpresisi tinggi hingga 7 angka desimal.
3. **Tombol "Dapatkan Lokasi Saya"**: Mensimulasikan siklus permintaan izin akses lokasi (`ACCESS_FINE_LOCATION`) dan pembacaan sinyal GPS satelit secara asinkron.
4. **Canvas Map Visualizer**: Menampilkan proyeksi titik lokasi di tengah bidang peta dengan pin marker merah dan kontrol zoom level (3x hingga 20x).
5. **Preset Pindah Lokasi**: Pengujian perpindahan titik kamera ke berbagai kota (Jakarta, Bandung, Yogyakarta, Surabaya, Denpasar) untuk memvalidasi reaktivitas UI.

```dart
// lib/pert7/praktikum/praktikum7_page.dart
void _simulasikanBacaLokasiGps() {
  setState(() {
    _isLoading = true;
    _statusMessage = 'Meminta izin ACCESS_FINE_LOCATION & membaca sinyal GPS satelit...';
  });

  Future.delayed(const Duration(milliseconds: 900), () {
    setState(() {
      _isLoading = false;
      _currentLat = -6.1895231;
      _currentLng = 106.7681442;
      _locationName = 'Universitas Esa Unggul (Posisi Perangkat Terdeteksi)';
      _statusMessage = 'Lokasi berhasil diperoleh via Location Provider (GPS/Satelit)';
      _hasCustomLocation = true;
    });
  });
}
```

---

## BAB IV: Pembahasan Tugas (Aplikasi PetaWisata Indonesia)

Pada tugas Pertemuan 7, dikembangkan aplikasi **PetaWisata Indonesia** yang menggabungkan seluruh konsep LBS dalam studi kasus pariwisata nusantara:
1. **Model Data Wisata**: Memuat 15 destinasi pariwisata Indonesia yang terbagi dalam 5 kategori: Candi, Gunung, Pantai, Danau, dan Kota (contoh: Borobudur, Bromo, Pantai Kuta, Danau Toba, Labuan Bajo, Kawah Ijen, dll.).
2. **Perhitungan Jarak Otomatis**: Setiap destinasi secara dinamis menghitung jaraknya terhadap posisi pengguna menggunakan rumus Haversine.
3. **Sorting Terdekat**: Daftar destinasi diurutkan secara otomatis dari jarak yang paling dekat dengan pengguna.
4. **Pencarian & Filter Kategori**: Pengguna dapat mencari berdasarkan nama destinasi, daerah, atau memfilter kategori menggunakan *ChoiceChip*.
5. **Peta Sebaran Interaktif**: Peta visual nusantara yang memplot posisi koordinat masing-masing destinasi wisata.
6. **Modal BottomSheet & Halaman Detail**: Menampilkan informasi lengkap mengenai harga tiket masuk, jam operasional, koordinat presisi, serta tombol integrasi rute Google Maps.

```dart
// lib/pert7/data/wisata_data.dart
double hitungJarakKm(double userLat, double userLng) {
  const double r = 6371; // Jari-jari bumi (km)
  final double dLat = _deg2rad(lintang - userLat);
  final double dLng = _deg2rad(bujur - userLng);

  final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_deg2rad(userLat)) *
          math.cos(_deg2rad(lintang)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);

  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return r * c;
}
```

---

## Tabel Pemetaan Komponen Modul vs Implementasi Flutter
| Komponen Modul 7 | Implementasi Kode Flutter | Fungsi & Peran |
| :--- | :--- | :--- |
| **Location Provider** | `geolocator` / `_simulasikanBacaLokasiGps` | Membaca titik koordinat lintang & bujur perangkat dari satelit GPS. |
| **Location Manager** | `CustomPaint` / `GoogleMap` widget | Merender peta grafis, marker pin, dan kontrol camera zoom. |
| **Marker & InfoWindow** | `Icons.location_on` & Modal BottomSheet | Menandai posisi geografis dan menampilkan ringkasan data objek wisata. |
| **Haversine Distance** | `hitungJarakKm()` | Menghitung jarak spasial antara pengguna dengan destinasi wisata. |
| **Google Maps Navigation** | Navigasi Intent / URL Scheme Maps | Membuka rute panduan jalan menuju koordinat tujuan di Google Maps. |

---

## BAB V: Kesimpulan & Refleksi
1. Penerapan Location Based Service pada Flutter dapat dijalankan secara efisien dengan memisahkan penanganan *Location Provider* (pembacaan koordinat) dan *Location Manager* (proyeksi visual peta).
2. Perhitungan jarak menggunakan formula Haversine memberikan akurasi spasial garis lurus yang andal untuk mengurutkan fasilitas atau objek wisata terdekat.
3. Penanganan izin runtime Android (`ACCESS_FINE_LOCATION`) sangat penting untuk memastikan privasi pengguna tetap terlindungi sekaligus menjaga stabilitas aplikasi saat GPS dimatikan.
