import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/aktivitas_tabungan.dart';

final ValueNotifier<int> dataVersion = ValueNotifier<int>(0);

class TabungKuRepository {
  TabungKuRepository._();
  static final TabungKuRepository instance = TabungKuRepository._();
  Future<Database>? _databaseFuture;

  Future<Database> get database => _databaseFuture ??= _open();

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    return openDatabase(
      path.join(root, 'tabungku.db'),
      version: 2,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE kegiatan (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          judul TEXT NOT NULL,
          tanggal TEXT NOT NULL,
          selesai INTEGER NOT NULL DEFAULT 0,
          tipe TEXT NOT NULL,
          nominal INTEGER NOT NULL DEFAULT 0,
          kategori TEXT NOT NULL DEFAULT '-',
          catatan TEXT NOT NULL DEFAULT ''
        )
      '''),
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE kegiatan ADD COLUMN catatan TEXT NOT NULL DEFAULT ''");
        }
      },
    );
  }

  Future<List<AktivitasTabungan>> aktivitasPadaTanggal(String tanggal) async {
    final rows = await (await database).query('kegiatan', where: 'tanggal = ?', whereArgs: [tanggal], orderBy: 'id DESC');
    return rows.map((row) => AktivitasTabungan.fromMap(Map<String, Object?>.from(row))).toList();
  }

  Future<int> tambah(AktivitasTabungan kegiatan) async {
    final id = await (await database).insert('kegiatan', kegiatan.toMap()..remove('id'));
    dataVersion.value++;
    return id;
  }

  Future<void> ubah(AktivitasTabungan kegiatan) async {
    if (kegiatan.id == null) return;
    await (await database).update('kegiatan', kegiatan.toMap()..remove('id'), where: 'id = ?', whereArgs: [kegiatan.id]);
    dataVersion.value++;
  }

  Future<void> hapus(int id) async {
    await (await database).delete('kegiatan', where: 'id = ?', whereArgs: [id]);
    dataVersion.value++;
  }

  Future<void> setSelesai(AktivitasTabungan kegiatan, bool selesai) async {
    if (kegiatan.id == null) return;
    await (await database).update('kegiatan', {'selesai': selesai ? 1 : 0}, where: 'id = ?', whereArgs: [kegiatan.id]);
    dataVersion.value++;
  }

  Future<RingkasanHari> ringkasanHari(String tanggal) async {
    final rows = await (await database).rawQuery('''
      SELECT COUNT(*) AS jumlah,
        COALESCE(SUM(selesai), 0) AS selesai,
        COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN nominal ELSE 0 END), 0) AS masuk,
        COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal ELSE 0 END), 0) AS keluar
      FROM kegiatan WHERE tanggal = ?
    ''', [tanggal]);
    final row = rows.first;
    return RingkasanHari(
      jumlah: (row['jumlah'] as num).toInt(),
      selesai: (row['selesai'] as num).toInt(),
      pemasukan: (row['masuk'] as num).toInt(),
      pengeluaran: (row['keluar'] as num).toInt(),
    );
  }

  Future<Map<String, int>> pengeluaranPerKategoriHari(String tanggal) async {
    final rows = await (await database).rawQuery('''
      SELECT kategori, COALESCE(SUM(nominal), 0) AS total
      FROM kegiatan WHERE tanggal = ? AND tipe = 'pengeluaran'
      GROUP BY kategori ORDER BY total DESC
    ''', [tanggal]);
    return {for (final row in rows) row['kategori'] as String: (row['total'] as num).toInt()};
  }

  Future<Map<String, RingkasanHari>> ringkasanTujuhHari(String tanggalAkhir) async {
    final start = DateTime.parse(tanggalAkhir).subtract(const Duration(days: 6)).toIso8601String().substring(0, 10);
    final rows = await (await database).rawQuery('''
      SELECT tanggal, COUNT(*) AS jumlah, COALESCE(SUM(selesai), 0) AS selesai,
        COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN nominal ELSE 0 END), 0) AS masuk,
        COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal ELSE 0 END), 0) AS keluar
      FROM kegiatan WHERE tanggal BETWEEN ? AND ? GROUP BY tanggal ORDER BY tanggal
    ''', [start, tanggalAkhir]);
    return {
      for (final row in rows)
        row['tanggal'] as String: RingkasanHari(
          jumlah: (row['jumlah'] as num).toInt(),
          selesai: (row['selesai'] as num).toInt(),
          pemasukan: (row['masuk'] as num).toInt(),
          pengeluaran: (row['keluar'] as num).toInt(),
        ),
    };
  }

  Future<RingkasanHari> ringkasanBulan(String bulan) async {
    final rows = await (await database).rawQuery('''
      SELECT COUNT(*) AS jumlah, COALESCE(SUM(selesai), 0) AS selesai,
        COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN nominal ELSE 0 END), 0) AS masuk,
        COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal ELSE 0 END), 0) AS keluar
      FROM kegiatan WHERE tanggal LIKE ?
    ''', ['$bulan-%']);
    final row = rows.first;
    return RingkasanHari(
      jumlah: (row['jumlah'] as num).toInt(),
      selesai: (row['selesai'] as num).toInt(),
      pemasukan: (row['masuk'] as num).toInt(),
      pengeluaran: (row['keluar'] as num).toInt(),
    );
  }
}
