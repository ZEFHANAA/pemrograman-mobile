import 'package:flutter/material.dart';

import '../models/splw_models.dart';
import '../state/splw_state.dart';
import '../theme/splw_theme.dart';
import 'detail_screen.dart';

class SavedScreen extends StatefulWidget {
  final SplwState state;
  final VoidCallback onRequireLogin;
  final VoidCallback onRequireRegister;
  final VoidCallback onNavigateToMap;

  const SavedScreen({
    super.key,
    required this.state,
    required this.onRequireLogin,
    required this.onRequireRegister,
    required this.onNavigateToMap,
  });

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String _selectedKategori = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmDeleteLokasi(LokasiModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus lokasi?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          '"${item.namaLokasi}" akan dihapus dari daftar tersimpan. Tindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            key: const Key('saved_delete_confirm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: SplwTheme.dangerRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    final messenger = ScaffoldMessenger.of(context);
    final error = widget.state.deleteLokasi(item.id);
    if (!mounted) return;
    setState(() {});
    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: SplwTheme.dangerRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text('Lokasi "${item.namaLokasi}" berhasil dihapus.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmDeleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Semua Lokasi?'),
        content: const Text(
          'Seluruh lokasi yang tersimpan pada akun Anda akan dihapus permanen. Lanjutkan?',
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            key: const Key('saved_delete_all_confirm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: SplwTheme.dangerRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    final error = widget.state.deleteAllMyLokasi();
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? 'Semua lokasi tersimpan berhasil dikosongkan.',
        ),
        backgroundColor: error == null ? null : SplwTheme.dangerRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportExcelMock(List<LokasiModel> items) {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada data untuk diekspor.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.table_view, color: SplwTheme.successGreen),
            SizedBox(width: 8),
            Expanded(child: Text('Ekspor Data (simulasi)')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prototipe menyiapkan ${items.length} baris data lokasi untuk ekspor:',
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: SplwTheme.softPrimaryOf(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'lokasi_wisata_user.xlsx',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Catatan: prototipe ini tidak benar-benar membuat berkas .xlsx.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SplwTheme.primaryTeal,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.state.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: SplwTheme.surfaceOf(context),
        appBar: AppBar(title: const Text('Lokasi Tersimpan')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: SplwTheme.softPrimaryOf(context),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark_border,
                    size: 44,
                    color: SplwTheme.primaryTeal,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Masuk untuk Menyimpan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: SplwTheme.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fitur penyimpanan lokasi memerlukan akun aktif (BR-01). Masuk atau daftar untuk mulai menyimpan lokasi wisata favorit Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SplwTheme.textSecondaryOf(context),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('saved_guest_login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SplwTheme.primaryTeal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: widget.onRequireLogin,
                    child: const Text(
                      'Masuk Akun',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    key: const Key('saved_guest_register'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SplwTheme.primaryTeal,
                      side: const BorderSide(
                        color: SplwTheme.primaryTeal,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: widget.onRequireRegister,
                    child: const Text(
                      'Daftar Akun Baru',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final myLocations = widget.state.lokasis
        .where((lokasi) => lokasi.userId == user.id)
        .toList();

    final filteredList = myLocations.where((lokasi) {
      final matchKat =
          _selectedKategori == 'Semua' || lokasi.kategori == _selectedKategori;
      final query = _searchQuery.toLowerCase();
      final matchQuery = query.isEmpty ||
          lokasi.namaLokasi.toLowerCase().contains(query) ||
          lokasi.deskripsi.toLowerCase().contains(query) ||
          lokasi.kategori.toLowerCase().contains(query);
      return matchKat && matchQuery;
    }).toList();

    final card = SplwTheme.cardOf(context);
    final border = SplwTheme.borderOf(context);
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);
    final textMuted = SplwTheme.textMutedOf(context);

    return Scaffold(
      backgroundColor: SplwTheme.surfaceOf(context),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Lokasi Tersimpan'),
            const SizedBox(width: 8),
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${filteredList.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: SplwTheme.primaryTeal,
                ),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            key: const Key('saved_menu'),
            icon: const Icon(Icons.more_vert),
            tooltip: 'Menu Opsi',
            onSelected: (val) {
              if (val == 'export') {
                _exportExcelMock(filteredList);
              } else if (val == 'delete_all') {
                _confirmDeleteAll();
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Ekspor Excel (simulasi)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete_all',
                enabled: myLocations.isNotEmpty,
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete_sweep_outlined,
                      color: Colors.red,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Hapus Semua Lokasi',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: card,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: SplwTheme.inputFillOf(context),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 6),
                        child: Icon(
                          Icons.search,
                          size: 18,
                          color: textSecondary,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          key: const Key('saved_search_field'),
                          controller: _searchController,
                          onChanged: (val) =>
                              setState(() => _searchQuery = val.trim()),
                          style: TextStyle(fontSize: 13, color: textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Cari lokasi tersimpan',
                            hintStyle: TextStyle(
                              color: textMuted,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: kDaftarKategori.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (ctx, index) {
                      final kat = kDaftarKategori[index];
                      final isSelected = kat == _selectedKategori;
                      return GestureDetector(
                        key: Key('saved_filter_$kat'),
                        onTap: () =>
                            setState(() => _selectedKategori = kat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? SplwTheme.primaryTeal
                                : card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? SplwTheme.primaryTeal
                                  : border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              kat,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color:
                                    isSelected ? Colors.white : textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          Expanded(
            child: filteredList.isEmpty
                ? _buildEmptyState(
                    hasAnyLocation: myLocations.isNotEmpty,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: filteredList.length + 1,
                    itemBuilder: (ctx, index) {
                      if (index == filteredList.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                            child: Text(
                              'Geser kartu ke kiri untuk menghapus',
                              style:
                                  TextStyle(fontSize: 11, color: textMuted),
                            ),
                          ),
                        );
                      }

                      final item = filteredList[index];
                      final katColor =
                          SplwTheme.getCategoryColor(item.kategori);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Dismissible(
                          key: Key(item.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: SplwTheme.dangerRed,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          confirmDismiss: (_) async {
                            await _confirmDeleteLokasi(item);
                            return false;
                          },
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(
                                    state: widget.state,
                                    nama: item.namaLokasi,
                                    latitude: item.latitude,
                                    longitude: item.longitude,
                                    kategori: item.kategori,
                                    deskripsi: item.deskripsi,
                                    savedId: item.id,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: card,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: border),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: SplwTheme.isDark(context)
                                          ? 0.2
                                          : 0.05,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: katColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.namaLokasi,
                                                style: TextStyle(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: textPrimary,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (item.shareToken != null) ...[
                                              const SizedBox(width: 4),
                                              const Icon(
                                                Icons.link,
                                                size: 14,
                                                color: SplwTheme.primaryTeal,
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.kategori,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: katColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${item.latitude.toStringAsFixed(4)}, ${item.longitude.toStringAsFixed(4)}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: textMuted,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required bool hasAnyLocation}) {
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: SplwTheme.softPrimaryOf(context),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                size: 54,
                color: SplwTheme.primaryTeal,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasAnyLocation
                  ? 'Tidak ada hasil yang cocok'
                  : 'Belum ada lokasi tersimpan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasAnyLocation
                  ? 'Ubah kata kunci pencarian atau pilih kategori lain.'
                  : 'Cari lokasi wisata di peta, lalu simpan sebagai favorit Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('saved_empty_action'),
              style: ElevatedButton.styleFrom(
                backgroundColor: SplwTheme.primaryTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              onPressed: widget.onNavigateToMap,
              child: const Text(
                'Cari Lokasi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
