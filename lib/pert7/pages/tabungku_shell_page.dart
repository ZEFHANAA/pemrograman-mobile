import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/tabungku_repository.dart';
import '../data/tabungku_settings.dart';
import '../models/aktivitas_tabungan.dart';


class TabungKuShellPage extends StatefulWidget {
  const TabungKuShellPage({super.key});

  @override
  State<TabungKuShellPage> createState() => _TabungKuShellPageState();
}

class _TabungKuShellPageState extends State<TabungKuShellPage> {
  int _index = 0;
  static const _tabs = [
    _BerandaTab(),
    _LaporanTab(),
    _PengaturanTab(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _tabs[_index],
        floatingActionButton: _index == 0
            ? FloatingActionButton.extended(
                onPressed: () => Navigator.pushNamed(context, '/tabungku/form'),
                icon: const Icon(Icons.add),
                label: const Text('Tambah Aktivitas'),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.today), label: 'Hari Ini'),
            NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Laporan'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Pengaturan'),
          ],
        ),
      );
}

String _today() => _dayKey(DateTime.now());
String _dayKey(DateTime date) => '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
String _rupiah(int value) {
  final digits = value.abs().toString();
  final groups = <String>[];
  for (var end = digits.length; end > 0; end -= 3) {
    final start = end - 3 < 0 ? 0 : end - 3;
    groups.insert(0, digits.substring(start, end));
  }
  return 'Rp ${value < 0 ? '-' : ''}${groups.join('.')}';
}

class _BerandaTab extends StatefulWidget {
  const _BerandaTab();

  @override
  State<_BerandaTab> createState() => _BerandaTabState();
}

class _BerandaTabState extends State<_BerandaTab> {
  String _query = '';
  JenisKeuangan? _filterType;
  late Future<({List<AktivitasTabungan> items, RingkasanHari summary, int target})> _future;

  @override
  void initState() {
    super.initState();
    _load();
    dataVersion.addListener(_reload);
  }

  @override
  void dispose() {
    dataVersion.removeListener(_reload);
    super.dispose();
  }

  void _reload() => setState(_load);

  void _load() {
    _future = () async {
      final values = await Future.wait<Object>([
        TabungKuRepository.instance.aktivitasPadaTanggal(_today()),
        TabungKuRepository.instance.ringkasanHari(_today()),
        TabungKuSettings.getTarget(),
      ]);
      return (items: values[0] as List<AktivitasTabungan>, summary: values[1] as RingkasanHari, target: values[2] as int);
    }();
  }

  Future<void> _delete(AktivitasTabungan item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus kegiatan?'),
        content: Text('AktivitasTabungan "${item.judul}" akan dihapus.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (confirmed == true && item.id != null) await TabungKuRepository.instance.hapus(item.id!);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('TabungKu · Hari Ini')),
        body: ValueListenableBuilder<int>(
          valueListenable: dataVersion,
          builder: (context, _, __) => FutureBuilder<({List<AktivitasTabungan> items, RingkasanHari summary, int target})>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Center(child: Text('Gagal membaca data: ${snapshot.error}'));
              final data = snapshot.data!;
              final filteredItems = data.items.where((item) {
                final matchesText = item.judul.toLowerCase().contains(_query.toLowerCase()) ||
                    item.kategori.toLowerCase().contains(_query.toLowerCase());
                return matchesText && (_filterType == null || item.tipe == _filterType);
              }).toList();
              final progress = data.target <= 0 ? 0.0 : (data.summary.tabungan / data.target).clamp(0.0, 1.0).toDouble();
              return Column(children: [
                Card(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Ringkasan ${_today()}', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 10),
                      Text('${data.summary.selesai}/${data.summary.jumlah} kegiatan selesai'),
                      Text('Pemasukan ${_rupiah(data.summary.pemasukan)} · Pengeluaran ${_rupiah(data.summary.pengeluaran)}'),
                      Text('Tabungan hari ini ${_rupiah(data.summary.tabungan)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 650),
                        builder: (context, value, _) => LinearProgressIndicator(value: value, minHeight: 10),
                      ),
                      const SizedBox(height: 4),
                      Text(data.summary.tabungan < 0
                          ? 'Pengeluaran lebih besar dari pemasukan.'
                          : progress >= 1 ? 'Target ${_rupiah(data.target)} tercapai. Bagus!' : 'Target harian ${_rupiah(data.target)}'),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Cari kegiatan atau kategori',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) => setState(() => _query = value.trim()),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(children: [
                    ChoiceChip(label: const Text('Semua'), selected: _filterType == null, onSelected: (_) => setState(() => _filterType = null)),
                    const SizedBox(width: 8),
                    ...JenisKeuangan.values.map((type) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(type == JenisKeuangan.tanpa ? 'Tanpa uang' : type == JenisKeuangan.pemasukan ? 'Pemasukan' : 'Pengeluaran'),
                        selected: _filterType == type,
                        onSelected: (_) => setState(() => _filterType = type),
                      ),
                    )),
                  ]),
                ),
                Expanded(child: filteredItems.isEmpty
                    ? const Center(child: Text('Belum ada kegiatan hari ini.'))
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          final subtitle = item.tipe == JenisKeuangan.tanpa
                              ? 'Tidak melibatkan uang'
                              : '${item.tipe == JenisKeuangan.pemasukan ? 'Pemasukan' : 'Pengeluaran'} · ${_rupiah(item.nominal)}${item.kategori == '-' ? '' : ' · ${item.kategori}'}';
                          final detail = item.catatan.isEmpty ? subtitle : '$subtitle\nCatatan: ${item.catatan}';
                          return CheckboxListTile(
                            value: item.selesai,
                            title: Text(item.judul, style: TextStyle(decoration: item.selesai ? TextDecoration.lineThrough : null)),
                            subtitle: Text(detail),
                            onChanged: (value) => TabungKuRepository.instance.setSelesai(item, value ?? false),
                            secondary: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') Navigator.pushNamed(context, '/tabungku/form', arguments: item);
                                if (value == 'delete') _delete(item);
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'edit', child: Text('Ubah')),
                                PopupMenuItem(value: 'delete', child: Text('Hapus')),
                              ],
                            ),
                          );
                        },
                      )),
              ]);
            },
          ),
        ),
      );
}

class _LaporanTab extends StatefulWidget {
  const _LaporanTab();

  @override
  State<_LaporanTab> createState() => _LaporanTabState();
}

class _LaporanTabState extends State<_LaporanTab> {
  DateTime _date = DateTime.now();
  late Future<({RingkasanHari summary, Map<String, int> categories, Map<String, RingkasanHari> week, RingkasanHari monthly})> _future;

  @override
  void initState() {
    super.initState();
    _load();
    dataVersion.addListener(_reload);
  }

  @override
  void dispose() {
    dataVersion.removeListener(_reload);
    super.dispose();
  }

  void _reload() => setState(_load);

  void _load() {
    final key = _dayKey(_date);
    _future = () async {
      final values = await Future.wait<Object>([
        TabungKuRepository.instance.ringkasanHari(key),
        TabungKuRepository.instance.pengeluaranPerKategoriHari(key),
        TabungKuRepository.instance.ringkasanTujuhHari(key),
        TabungKuRepository.instance.ringkasanBulan(key.substring(0, 7)),
      ]);
      return (
        summary: values[0] as RingkasanHari,
        categories: values[1] as Map<String, int>,
        week: values[2] as Map<String, RingkasanHari>,
        monthly: values[3] as RingkasanHari,
      );
    }();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (date != null) setState(() { _date = date; _load(); });
  }

  Future<void> _exportSummary() async {
    final data = await _future;
    final text = [
      'Laporan ${_dayKey(_date)}',
      'Aktivitas: ${data.summary.selesai}/${data.summary.jumlah} selesai',
      'Pemasukan: ${_rupiah(data.summary.pemasukan)}',
      'Pengeluaran: ${_rupiah(data.summary.pengeluaran)}',
      'Tabungan: ${_rupiah(data.summary.tabungan)}',
      if (data.categories.isNotEmpty) 'Kategori: ${data.categories.entries.map((e) => '${e.key} ${_rupiah(e.value)}').join(', ')}',
    ].join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ringkasan disalin ke clipboard.')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('TabungKu · Laporan'), actions: [IconButton(onPressed: _exportSummary, icon: const Icon(Icons.copy_all)), IconButton(onPressed: _pickDate, icon: const Icon(Icons.calendar_month))]),
        body: ValueListenableBuilder<int>(
          valueListenable: dataVersion,
          builder: (context, _, __) => FutureBuilder<({RingkasanHari summary, Map<String, int> categories, Map<String, RingkasanHari> week, RingkasanHari monthly})>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Center(child: Text('Gagal menghitung laporan: ${snapshot.error}'));
              final data = snapshot.data!;
              return ListView(padding: const EdgeInsets.all(16), children: [
                Text('Laporan ${_dayKey(_date)}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Aktivitas: ${data.summary.selesai}/${data.summary.jumlah} selesai'),
                Text('Pemasukan: ${_rupiah(data.summary.pemasukan)}'),
                Text('Pengeluaran: ${_rupiah(data.summary.pengeluaran)}'),
                Text('Tabungan: ${_rupiah(data.summary.tabungan)}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 18),
                Text('Pengeluaran per kategori', style: Theme.of(context).textTheme.titleMedium),
                if (data.categories.isEmpty) const ListTile(title: Text('Belum ada pengeluaran pada tanggal ini.')),
                ...data.categories.entries.map((item) => ListTile(title: Text(item.key), trailing: Text(_rupiah(item.value)))),
                const SizedBox(height: 18),
                Text('Tujuh hari hingga tanggal terpilih', style: Theme.of(context).textTheme.titleMedium),
                ...List.generate(7, (index) {
                  final date = _date.subtract(Duration(days: 6 - index));
                  final key = _dayKey(date);
                  final summary = data.week[key];
                  return ListTile(
                    dense: true,
                    title: Text(key),
                    subtitle: Text('${summary?.jumlah ?? 0} kegiatan'),
                    trailing: Text(_rupiah(summary?.tabungan ?? 0)),
                  );
                }),
                const SizedBox(height: 18),
                Text('Ringkasan bulan ${_dayKey(_date).substring(0, 7)}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Pemasukan ${_rupiah(data.monthly.pemasukan)} · Pengeluaran ${_rupiah(data.monthly.pengeluaran)}'),
                Text('Tabungan bulan ini ${_rupiah(data.monthly.tabungan)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Perbandingan pemasukan dan pengeluaran'),
                const SizedBox(height: 4),
                _MonthlyBar(label: 'Pemasukan', value: data.monthly.pemasukan, max: data.monthly.pemasukan > data.monthly.pengeluaran ? data.monthly.pemasukan : data.monthly.pengeluaran, color: Colors.green),
                _MonthlyBar(label: 'Pengeluaran', value: data.monthly.pengeluaran, max: data.monthly.pemasukan > data.monthly.pengeluaran ? data.monthly.pemasukan : data.monthly.pengeluaran, color: Colors.red),
              ]);
            },
          ),
        ),
      );
}

class _MonthlyBar extends StatelessWidget {
  const _MonthlyBar({required this.label, required this.value, required this.max, required this.color});
  final String label;
  final int value;
  final int max;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          SizedBox(width: 92, child: Text(label)),
          Expanded(child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: max == 0 ? 0 : value / max),
            duration: const Duration(milliseconds: 500),
            builder: (context, amount, _) => LinearProgressIndicator(value: amount, color: color),
          )),
          const SizedBox(width: 8),
          Text(_rupiah(value)),
        ]),
      );
}

class _PengaturanTab extends StatefulWidget {
  const _PengaturanTab();

  @override
  State<_PengaturanTab> createState() => _PengaturanTabState();
}

class _PengaturanTabState extends State<_PengaturanTab> {
  int _target = 20000;
  bool _dark = false;
  int _seed = Colors.teal.toARGB32();
  bool _loaded = false;
  static const _colors = [Colors.teal, Colors.green, Colors.amber, Colors.pink, Colors.blueGrey];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) _load();
  }

  Future<void> _load() async {
    final values = await Future.wait<Object>([
      TabungKuSettings.getTarget(),
      TabungKuSettings.getDarkMode(),
      TabungKuSettings.getColorSeed(),
    ]);
    if (!mounted) return;
    setState(() {
      _target = values[0] as int;
      _dark = values[1] as bool;
      _seed = values[2] as int;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('TabungKu · Pengaturan')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Text('Target tabungan harian: ${_rupiah(_target)}', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            min: 5000,
            max: 100000,
            divisions: 19,
            value: _target.clamp(5000, 100000).toDouble(),
            label: _rupiah(_target),
            onChanged: (value) => setState(() => _target = value.round()),
            onChangeEnd: (value) => TabungKuSettings.setTarget(value.round()),
          ),
          SwitchListTile(
            title: const Text('Mode gelap'),
            value: _dark,
            onChanged: (value) async {
              setState(() => _dark = value);
              await TabungKuSettings.setDarkMode(value);
            },
          ),
          const ListTile(title: Text('Warna tema')),
          Wrap(spacing: 10, children: _colors.map((color) => ChoiceChip(
            label: Text(color == Colors.teal ? 'Teal' : color == Colors.green ? 'Hijau' : color == Colors.amber ? 'Amber' : color == Colors.pink ? 'Merah Muda' : 'Abu'),
            selected: color.toARGB32() == _seed,
            avatar: CircleAvatar(backgroundColor: color, radius: 9),
            onSelected: (_) async {
              setState(() => _seed = color.toARGB32());
              await TabungKuSettings.setColorSeed(color.toARGB32());
            },
          )).toList()),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.cloud_outlined),
            title: const Text('Status TabungKu Cloud'),
            subtitle: const Text('Pertemuan 8 · FastAPI dan MySQL'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/status'),
          ),
        ]),
      );
}

class Praktikum7Page extends StatelessWidget {
  const Praktikum7Page({super.key});
  @override
  Widget build(BuildContext context) => const TabungKuShellPage();
}

class Tugas7Page extends StatelessWidget {
  const Tugas7Page({super.key});
  @override
  Widget build(BuildContext context) => const TabungKuShellPage();
}
