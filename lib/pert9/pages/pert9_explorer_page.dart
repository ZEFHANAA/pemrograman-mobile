import 'package:flutter/material.dart';

import '../../pert7/models/aktivitas_tabungan.dart';
import '../../pert8/data/health_service.dart';
import '../models/aktivitas_cloud.dart';
import '../services/aktivitas_cloud_api.dart';
import '../services/laporan_cloud_api.dart';

/// Halaman eksplorasi REST API CRUD (Praktikum 9) dan Laporan SQL (Tugas 9).
class Pert9ExplorerPage extends StatefulWidget {
  const Pert9ExplorerPage({
    super.key,
    required this.title,
    this.initialTab = 0,
  });

  final String title;
  final int initialTab;

  @override
  State<Pert9ExplorerPage> createState() => _Pert9ExplorerPageState();
}

class _Pert9ExplorerPageState extends State<Pert9ExplorerPage> {
  final AktivitasCloudApi _kegiatanApi = AktivitasCloudApi();
  final LaporanCloudApi _laporanApi = LaporanCloudApi();
  final HealthService _healthService = HealthService();

  late int _tabIndex;
  String _apiUrl = defaultApiUrl;
  bool _loading = false;
  String? _errorMsg;

  List<AktivitasCloud> _items = _demoItems;
  LaporanHarianCloud _laporan = _demoLaporan;

  static const List<AktivitasCloud> _demoItems = [
    AktivitasCloud(
      id: 1,
      judul: 'Uang saku mingguan',
      tanggal: '2026-10-05',
      selesai: true,
      tipe: JenisKeuangan.pemasukan,
      nominal: 50000,
      kategori: '-',
    ),
    AktivitasCloud(
      id: 2,
      judul: 'Makan siang kampus',
      tanggal: '2026-10-05',
      selesai: true,
      tipe: JenisKeuangan.pengeluaran,
      nominal: 15000,
      kategori: 'Makan',
    ),
    AktivitasCloud(
      id: 3,
      judul: 'Naik ojek ke kampus',
      tanggal: '2026-10-05',
      selesai: false,
      tipe: JenisKeuangan.pengeluaran,
      nominal: 10000,
      kategori: 'Transport',
    ),
    AktivitasCloud(
      id: 4,
      judul: 'Latihan REST API FastAPI',
      tanggal: '2026-10-05',
      selesai: false,
      tipe: JenisKeuangan.tanpa,
      nominal: 0,
      kategori: '-',
    ),
  ];

  static const LaporanHarianCloud _demoLaporan = LaporanHarianCloud(
    tanggal: '2026-10-05',
    ringkasan: RingkasanCloud(
      jumlahKegiatan: 4,
      selesai: 2,
      pemasukan: 50000,
      pengeluaran: 25000,
      tabungan: 25000,
    ),
    perKategori: {'Makan': 15000, 'Transport': 10000},
  );

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTab;
    _loadUrl();
  }

  Future<void> _loadUrl() async {
    final url = await _healthService.getApiUrl();
    if (mounted) setState(() => _apiUrl = url);
  }

  Future<void> _syncServer() async {
    setState(() {
      _loading = true;
      _errorMsg = null;
    });
    try {
      if (_tabIndex == 0) {
        final list = await _kegiatanApi.daftar();
        if (mounted) setState(() => _items = list);
      } else {
        final rep = await _laporanApi.harian('2026-10-05');
        if (mounted) setState(() => _laporan = rep);
      }
    } catch (e) {
      if (mounted) setState(() => _errorMsg = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildCrudTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.api, color: Colors.teal),
            title: const Text('Endpoint CRUD /kegiatan'),
            subtitle: Text('Server: $_apiUrl'),
            trailing: FilledButton.tonal(
              onPressed: _loading ? null : _syncServer,
              child: const Text('Muat'),
            ),
          ),
        ),
        if (_errorMsg != null) ...[
          const SizedBox(height: 8),
          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Mode pratinjau lokal (server belum aktif): $_errorMsg',
                style: TextStyle(color: Colors.amber.shade900, fontSize: 12),
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        for (final item in _items)
          Card(
            child: ListTile(
              leading: Icon(
                item.selesai ? Icons.check_circle : Icons.radio_button_unchecked,
                color: item.selesai ? Colors.teal : Colors.grey,
              ),
              title: Text(item.judul),
              subtitle: Text(
                '${item.tanggal} • ${item.tipe.name} • ${item.kategori}',
              ),
              trailing: Text(
                item.nominal > 0 ? 'Rp ${item.nominal}' : '-',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLaporanTab() {
    final r = _laporan.ringkasan;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.bar_chart, color: Colors.indigo),
            title: Text('Laporan Harian (${_laporan.tanggal})'),
            subtitle: Text('GET /laporan/harian • $_apiUrl'),
            trailing: FilledButton.tonal(
              onPressed: _loading ? null : _syncServer,
              child: const Text('Hitung'),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text('Pemasukan', style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${r.pemasukan}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text('Pengeluaran', style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${r.pengeluaran}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Card(
          child: ListTile(
            title: const Text('Tabungan Bersih'),
            subtitle: Text(
              'Kegiatan: ${r.jumlahKegiatan} (${r.selesai} selesai)',
            ),
            trailing: Text(
              'Rp ${r.tabungan}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pengeluaran per Kategori (SQL GROUP BY)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        for (final entry in _laporan.perKategori.entries)
          Card(
            child: ListTile(
              title: Text(entry.key),
              trailing: Text(
                'Rp ${entry.value}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _tabIndex == 0 ? _buildCrudTab() : _buildLaporanTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (idx) => setState(() => _tabIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'CRUD API',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Laporan SQL',
          ),
        ],
      ),
    );
  }
}
