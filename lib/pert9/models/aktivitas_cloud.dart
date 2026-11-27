import '../../pert7/models/aktivitas_tabungan.dart';

/// Model aktivitas TabungKu untuk pertukaran JSON dengan FastAPI Pertemuan 9.
class AktivitasCloud {
  const AktivitasCloud({
    this.id,
    required this.judul,
    required this.tanggal,
    required this.selesai,
    required this.tipe,
    required this.nominal,
    required this.kategori,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String judul;
  final String tanggal;
  final bool selesai;
  final JenisKeuangan tipe;
  final int nominal;
  final String kategori;
  final String? createdAt;
  final String? updatedAt;

  Map<String, Object?> toJson() => {
        'judul': judul,
        'tanggal': tanggal,
        'selesai': selesai,
        'tipe': tipe.name,
        'nominal': nominal,
        'kategori': kategori,
      };

  factory AktivitasCloud.fromJson(Map<String, dynamic> json) => AktivitasCloud(
        id: json['id'] as int?,
        judul: json['judul'] as String,
        tanggal: json['tanggal'] as String,
        selesai: json['selesai'] as bool,
        tipe: JenisKeuangan.values.byName(json['tipe'] as String),
        nominal: json['nominal'] as int,
        kategori: json['kategori'] as String,
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
      );
}

class RingkasanCloud {
  const RingkasanCloud({
    required this.jumlahKegiatan,
    required this.selesai,
    required this.pemasukan,
    required this.pengeluaran,
    required this.tabungan,
  });

  final int jumlahKegiatan;
  final int selesai;
  final int pemasukan;
  final int pengeluaran;
  final int tabungan;

  factory RingkasanCloud.fromJson(Map<String, dynamic> json) => RingkasanCloud(
        jumlahKegiatan: json['jumlah_kegiatan'] as int,
        selesai: json['selesai'] as int,
        pemasukan: json['pemasukan'] as int,
        pengeluaran: json['pengeluaran'] as int,
        tabungan: json['tabungan'] as int,
      );
}

class LaporanHarianCloud {
  const LaporanHarianCloud({
    required this.tanggal,
    required this.ringkasan,
    required this.perKategori,
  });

  final String tanggal;
  final RingkasanCloud ringkasan;
  final Map<String, int> perKategori;

  factory LaporanHarianCloud.fromJson(Map<String, dynamic> json) {
    final rawKategori = (json['per_kategori'] as List<dynamic>? ?? []);
    return LaporanHarianCloud(
      tanggal: json['tanggal'] as String,
      ringkasan: RingkasanCloud.fromJson(json),
      perKategori: {
        for (final item in rawKategori)
          (item as Map<String, dynamic>)['kategori'] as String:
              item['total'] as int,
      },
    );
  }
}
