import 'package:flutter/material.dart';

import '../models/splw_models.dart';
import '../state/splw_state.dart';
import '../theme/splw_theme.dart';
import '../utils/splw_format.dart';
import '../widgets/form_lokasi_sheet.dart';

class AdminScreen extends StatelessWidget {
  final SplwState state;

  const AdminScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);
    final textMuted = SplwTheme.textMutedOf(context);
    final card = SplwTheme.cardOf(context);
    final border = SplwTheme.borderOf(context);
    final softPrimary = SplwTheme.softPrimaryOf(context);
    final recentLogs = state.logs.take(4).toList();
    final topCategory = state.topCategory;
    final mostActive = state.mostActiveUser;

    return Scaffold(
      backgroundColor: SplwTheme.surfaceOf(context),
      appBar: AppBar(title: const Text('Menu Admin')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ringkasan Sistem',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                Text(
                  'data mock',
                  style: TextStyle(fontSize: 11, color: textMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    context,
                    key: const Key('admin_stat_users'),
                    value: '${state.totalUsers}',
                    label: 'Total Pengguna',
                    background: softPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    context,
                    key: const Key('admin_stat_locations'),
                    value: '${state.totalLokasi}',
                    label: 'Total Lokasi',
                    background: softPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  _buildStatRow(
                    context,
                    'Rata-rata lokasi/pengguna',
                    state.averageLokasiPerUser.toStringAsFixed(1),
                  ),
                  Divider(height: 16, color: border),
                  _buildStatRow(
                    context,
                    'Pengguna paling aktif',
                    mostActive?.name ?? '-',
                  ),
                  Divider(height: 16, color: border),
                  _buildStatRow(
                    context,
                    'Kategori terpopuler',
                    topCategory ?? '-',
                    valueColor: topCategory == null
                        ? null
                        : SplwTheme.getCategoryColor(topCategory),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Log terbaru',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                TextButton(
                  key: const Key('admin_logs_shortcut'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminLogAktivitasScreen(state: state),
                      ),
                    );
                  },
                  child: const Text(
                    'Lihat semua',
                    style: TextStyle(
                      fontSize: 12,
                      color: SplwTheme.primaryTeal,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: recentLogs.isEmpty
                  ? Text(
                      'Belum ada aktivitas.',
                      style: TextStyle(fontSize: 12, color: textSecondary),
                    )
                  : Column(
                      children: [
                        for (var i = 0; i < recentLogs.length; i++) ...[
                          if (i > 0) Divider(height: 14, color: border),
                          _buildMiniLog(context, recentLogs[i]),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            _buildAdminMenuTile(
              context,
              key: const Key('admin_menu_users'),
              icon: Icons.people_outline,
              title: 'Kelola Pengguna',
              subtitle: 'Ubah data, role, dan status akun',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminPenggunaScreen(state: state),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildAdminMenuTile(
              context,
              key: const Key('admin_menu_locations'),
              icon: Icons.map_outlined,
              title: 'Moderasi Lokasi',
              subtitle: 'Ubah atau hapus lokasi pengguna',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminLokasiScreen(state: state),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildAdminMenuTile(
              context,
              key: const Key('admin_menu_stats'),
              icon: Icons.insights_outlined,
              title: 'Statistik',
              subtitle: 'Ringkasan data pengguna dan lokasi',
              onTap: () => _showStatsDialog(context),
            ),
            const SizedBox(height: 10),
            _buildAdminMenuTile(
              context,
              key: const Key('admin_menu_logs'),
              icon: Icons.history,
              title: 'Log Aktivitas',
              subtitle: 'Audit aktivitas sistem (BR-17)',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminLogAktivitasScreen(state: state),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
    BuildContext context, {
    required Key key,
    required String value,
    required String label,
    required Color background,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: SplwTheme.primaryTeal,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: SplwTheme.textSecondaryOf(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              color: SplwTheme.textSecondaryOf(context),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: valueColor ?? SplwTheme.textPrimaryOf(context),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniLog(BuildContext context, ActivityLogModel log) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${log.userName} - ${actionLabel(log.action)}',
            style: TextStyle(
              fontSize: 12,
              color: SplwTheme.textSecondaryOf(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          formatTime(log.createdAt),
          style: TextStyle(
            fontSize: 11,
            color: SplwTheme.textMutedOf(context),
          ),
        ),
      ],
    );
  }

  Widget _buildAdminMenuTile(
    BuildContext context, {
    required Key key,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: SplwTheme.cardOf(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: SplwTheme.borderOf(context)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: SplwTheme.primaryTeal),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: SplwTheme.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: SplwTheme.textMutedOf(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: SplwTheme.textMutedOf(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatsDialog(BuildContext context) {
    final topCategory = state.topCategory;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Statistik Sistem'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total pengguna: ${state.totalUsers}'),
            Text('Total lokasi: ${state.totalLokasi}'),
            Text(
              'Rata-rata lokasi/pengguna: ${state.averageLokasiPerUser.toStringAsFixed(1)}',
            ),
            Text('Pengguna paling aktif: ${state.mostActiveUser?.name ?? '-'}'),
            Text('Kategori terpopuler: ${topCategory ?? '-'}'),
            const SizedBox(height: 10),
            const Text(
              'Statistik dihitung langsung dari data mock in-memory.',
              style: TextStyle(fontSize: 11.5),
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
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

class AdminPenggunaScreen extends StatefulWidget {
  final SplwState state;

  const AdminPenggunaScreen({super.key, required this.state});

  @override
  State<AdminPenggunaScreen> createState() => _AdminPenggunaScreenState();
}

class _AdminPenggunaScreenState extends State<AdminPenggunaScreen> {
  String _query = '';

  Future<void> _showEditUserDialog(UserModel user) async {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    var role = user.role;
    String? error;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Ubah Data Pengguna'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      key: const Key('admin_edit_name'),
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Nama'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      key: const Key('admin_edit_email'),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      key: const Key('admin_edit_role'),
                      initialValue: role,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: const [
                        DropdownMenuItem(value: 'user', child: Text('User')),
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() {
                          role = value;
                          error = null;
                        });
                      },
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        error!,
                        style: const TextStyle(
                          color: SplwTheme.dangerRed,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  key: const Key('admin_edit_save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SplwTheme.primaryTeal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final message = widget.state.updateUserByAdmin(
                      id: user.id,
                      name: nameController.text,
                      email: emailController.text,
                      role: role,
                    );
                    if (message != null) {
                      setDialogState(() => error = message);
                      return;
                    }
                    Navigator.pop(ctx, true);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
    if (!mounted || saved != true) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data "${user.name}" berhasil diperbarui.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmDeleteUser(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus akun permanen?'),
        content: Text(
          'Akun "${user.name}" beserta seluruh lokasi miliknya akan dihapus (BR-16). Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            key: const Key('admin_delete_confirm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: SplwTheme.dangerRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    final error = widget.state.deleteUserByAdmin(user.id);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? 'Pengguna "${user.name}" berhasil dihapus.',
        ),
        backgroundColor: error == null ? null : SplwTheme.dangerRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showUserActionModal(UserModel user) {
    final isSelf = widget.state.currentUser?.id == user.id;
    final locationCount = widget.state.lokasis
        .where((lokasi) => lokasi.userId == user.id)
        .length;

    showModalBottomSheet(
      context: context,
      backgroundColor: SplwTheme.cardOf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: SplwTheme.borderOf(ctx),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: SplwTheme.textPrimaryOf(ctx),
              ),
            ),
            Text(
              '${user.email} | $locationCount lokasi',
              style: TextStyle(
                fontSize: 12,
                color: SplwTheme.textSecondaryOf(ctx),
              ),
            ),
            const Divider(height: 20),
            ListTile(
              key: const Key('admin_edit_user'),
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Ubah Data Pengguna'),
              subtitle: const Text('Nama, email, dan role akun'),
              onTap: () {
                Navigator.pop(ctx);
                _showEditUserDialog(user);
              },
            ),
            ListTile(
              key: const Key('admin_toggle_status'),
              leading: Icon(
                user.isActive ? Icons.block : Icons.check_circle,
                color: user.isActive
                    ? SplwTheme.warningOrange
                    : SplwTheme.successGreen,
              ),
              title: Text(
                user.isActive ? 'Nonaktifkan Akun' : 'Aktifkan Akun',
              ),
              subtitle: Text(
                isSelf
                    ? 'Admin tidak dapat menonaktifkan akun sendiri (BR-13)'
                    : 'Ubah status akses login',
              ),
              enabled: !isSelf,
              onTap: () {
                Navigator.pop(ctx);
                final error = widget.state.toggleUserStatusByAdmin(user.id);
                if (!mounted) return;
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error ??
                          'Status akun "${user.name}" berhasil diubah.',
                    ),
                    backgroundColor:
                        error == null ? null : SplwTheme.dangerRed,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              key: const Key('admin_delete_user'),
              leading: const Icon(
                Icons.delete_outline,
                color: SplwTheme.dangerRed,
              ),
              title: const Text(
                'Hapus Akun Permanen',
                style: TextStyle(color: SplwTheme.dangerRed),
              ),
              subtitle: Text(
                isSelf
                    ? 'Admin tidak dapat menghapus akun sendiri (BR-13)'
                    : 'Menghapus pengguna dan seluruh lokasinya (BR-16)',
              ),
              enabled: !isSelf,
              onTap: () {
                Navigator.pop(ctx);
                _confirmDeleteUser(user);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.state.users.where((user) {
      final query = _query.toLowerCase();
      return query.isEmpty ||
          user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
    }).toList();
    final card = SplwTheme.cardOf(context);
    final border = SplwTheme.borderOf(context);
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);

    return Scaffold(
      backgroundColor: SplwTheme.surfaceOf(context),
      appBar: AppBar(title: const Text('Kelola Pengguna')),
      body: Column(
        children: [
          Container(
            color: card,
            padding: const EdgeInsets.all(16),
            child: Container(
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
                      key: const Key('admin_user_search'),
                      onChanged: (val) =>
                          setState(() => _query = val.trim()),
                      style: TextStyle(fontSize: 13, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Cari nama atau email',
                        hintStyle: TextStyle(
                          color: SplwTheme.textMutedOf(context),
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
          ),
          Divider(height: 1, color: border),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'Pengguna tidak ditemukan.',
                      style: TextStyle(color: textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (ctx, index) {
                      final user = filtered[index];
                      final isSelf =
                          widget.state.currentUser?.id == user.id;
                      final locationCount = widget.state.lokasis
                          .where((lokasi) => lokasi.userId == user.id)
                          .length;
                      final isAdmin = user.role == 'admin';

                      return InkWell(
                        key: Key('admin_user_${user.id}'),
                        onTap: () => _showUserActionModal(user),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: SplwTheme.softPrimaryOf(context),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  user.name.isEmpty
                                      ? '?'
                                      : user.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: SplwTheme.primaryDark,
                                  ),
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
                                            user.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: textPrimary,
                                            ),
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isAdmin
                                                ? SplwTheme.primaryTeal
                                                : SplwTheme
                                                    .inputFillOf(context),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: isAdmin
                                                ? null
                                                : Border.all(color: border),
                                          ),
                                          child: Text(
                                            isAdmin ? 'Admin' : 'User',
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold,
                                              color: isAdmin
                                                  ? Colors.white
                                                  : textPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      user.email,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isSelf
                                          ? 'Anda | $locationCount lokasi'
                                          : '${user.isActive ? 'Aktif' : 'Nonaktif'} | $locationCount lokasi',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isSelf
                                            ? SplwTheme.primaryTeal
                                            : (user.isActive
                                                ? SplwTheme.successGreen
                                                : SplwTheme.dangerRed),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: SplwTheme.textMutedOf(context),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              'Ketuk pengguna untuk ubah, nonaktifkan, atau hapus.\nAdmin tidak dapat menonaktifkan akunnya sendiri (BR-13)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: SplwTheme.textMutedOf(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminLokasiScreen extends StatefulWidget {
  final SplwState state;

  const AdminLokasiScreen({super.key, required this.state});

  @override
  State<AdminLokasiScreen> createState() => _AdminLokasiScreenState();
}

class _AdminLokasiScreenState extends State<AdminLokasiScreen> {
  String _query = '';
  String _selectedKategori = 'Semua';

  String _ownerName(String userId) {
    for (final user in widget.state.users) {
      if (user.id == userId) return user.name;
    }
    return 'Pengguna tidak dikenal';
  }

  void _openEdit(LokasiModel lokasi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return FormLokasiBottomSheet(
          lokasiToEdit: lokasi,
          onSave: (nama, lat, lng, desc, kategori) {
            final error = widget.state.updateLokasi(
              id: lokasi.id,
              nama: nama,
              lat: lat,
              lng: lng,
              deskripsi: desc,
              kategori: kategori,
            );
            if (error != null) return error;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lokasi "$nama" berhasil diperbarui.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return null;
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(LokasiModel lokasi) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus lokasi?'),
        content: Text(
          '"${lokasi.namaLokasi}" akan dihapus dari sistem. Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            key: const Key('admin_lokasi_delete_confirm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: SplwTheme.dangerRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    final error = widget.state.deleteLokasi(lokasi.id);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? 'Lokasi "${lokasi.namaLokasi}" dihapus oleh Admin (BR-04).',
        ),
        backgroundColor: error == null ? null : SplwTheme.dangerRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.state.lokasis.where((lokasi) {
      final matchKat = _selectedKategori == 'Semua' ||
          lokasi.kategori == _selectedKategori;
      final query = _query.toLowerCase();
      final matchQuery = query.isEmpty ||
          lokasi.namaLokasi.toLowerCase().contains(query) ||
          lokasi.kategori.toLowerCase().contains(query) ||
          _ownerName(lokasi.userId).toLowerCase().contains(query);
      return matchKat && matchQuery;
    }).toList();
    final card = SplwTheme.cardOf(context);
    final border = SplwTheme.borderOf(context);
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);
    final textMuted = SplwTheme.textMutedOf(context);

    return Scaffold(
      backgroundColor: SplwTheme.surfaceOf(context),
      appBar: AppBar(title: const Text('Moderasi Lokasi')),
      body: Column(
        children: [
          Container(
            color: card,
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: SplwTheme.inputFillOf(context),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 6),
                        child: Icon(
                          Icons.search,
                          size: 18,
                          color: textSecondary,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          key: const Key('admin_location_search'),
                          onChanged: (val) =>
                              setState(() => _query = val.trim()),
                          style:
                              TextStyle(fontSize: 13, color: textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Cari nama lokasi atau pemilik',
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
                  height: 30,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: kDaftarKategori.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 6),
                    itemBuilder: (ctx, index) {
                      final kat = kDaftarKategori[index];
                      final isSelected = kat == _selectedKategori;
                      return GestureDetector(
                        key: Key('admin_location_filter_$kat'),
                        onTap: () =>
                            setState(() => _selectedKategori = kat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? SplwTheme.primaryTeal
                                : card,
                            borderRadius: BorderRadius.circular(14),
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
                                fontSize: 11.5,
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
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada lokasi yang cocok.',
                      style: TextStyle(color: textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (ctx, index) {
                      final lokasi = filtered[index];
                      final katColor =
                          SplwTheme.getCategoryColor(lokasi.kategori);

                      return Container(
                        key: Key('admin_location_${lokasi.id}'),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: katColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lokasi.namaLokasi,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${lokasi.kategori} | oleh ${_ownerName(lokasi.userId)}',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: katColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${lokasi.latitude.toStringAsFixed(4)}, ${lokasi.longitude.toStringAsFixed(4)}',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: textMuted,
                                    ),
                                  ),
                                  if (lokasi.shareToken != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.link,
                                          size: 13,
                                          color: SplwTheme.primaryTeal,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          'Tautan publik aktif',
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            color: textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      OutlinedButton(
                                        key: Key(
                                          'admin_location_edit_${lokasi.id}',
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              SplwTheme.primaryTeal,
                                          side: const BorderSide(
                                            color: SplwTheme.primaryTeal,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          minimumSize:
                                              const Size(60, 28),
                                        ),
                                        onPressed: () => _openEdit(lokasi),
                                        child: const Text(
                                          'Ubah',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      OutlinedButton(
                                        key: Key(
                                          'admin_location_delete_${lokasi.id}',
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              SplwTheme.dangerRed,
                                          side: const BorderSide(
                                            color: SplwTheme.dangerRed,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          minimumSize:
                                              const Size(60, 28),
                                        ),
                                        onPressed: () =>
                                            _confirmDelete(lokasi),
                                        child: const Text(
                                          'Hapus',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class AdminLogAktivitasScreen extends StatefulWidget {
  final SplwState state;

  const AdminLogAktivitasScreen({super.key, required this.state});

  @override
  State<AdminLogAktivitasScreen> createState() =>
      _AdminLogAktivitasScreenState();
}

class _AdminLogAktivitasScreenState extends State<AdminLogAktivitasScreen> {
  String _selectedFilter = 'Semua';

  Color _getDotColor(String action) {
    if (action.contains('DELETE')) return SplwTheme.dangerRed;
    if (action.contains('SHARE')) return SplwTheme.warningOrange;
    if (action.startsWith('ADMIN_')) return const Color(0xFF7E22CE);
    if (action.contains('LOGIN') || action.contains('REGISTER')) {
      return SplwTheme.successGreen;
    }
    return SplwTheme.primaryTeal;
  }

  void _showLogDetail(ActivityLogModel log) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Detail Log'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(actionLabel(log.action)),
            const SizedBox(height: 8),
            Text('Aktor: ${log.userName}'),
            Text('Entitas: ${log.entity}'),
            if (log.entityId != null) Text('ID entitas: ${log.entityId}'),
            Text('IP: ${log.ipAddress}'),
            Text('Waktu: ${formatDateTime(log.createdAt)}'),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SplwTheme.primaryTeal,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = ['Semua', 'Login', 'Lokasi', 'Admin', 'Demo'];
    final filtered = widget.state.logs.where((log) {
      if (_selectedFilter == 'Semua') return true;
      return actionCategoryLabel(log.action) == _selectedFilter;
    }).toList();
    final card = SplwTheme.cardOf(context);
    final border = SplwTheme.borderOf(context);
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);
    final textMuted = SplwTheme.textMutedOf(context);

    return Scaffold(
      backgroundColor: SplwTheme.surfaceOf(context),
      appBar: AppBar(title: const Text('Log Aktivitas')),
      body: Column(
        children: [
          Container(
            color: card,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final filter in filters)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        key: Key('admin_log_filter_$filter'),
                        onTap: () =>
                            setState(() => _selectedFilter = filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: filter == _selectedFilter
                                ? SplwTheme.primaryTeal
                                : card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: filter == _selectedFilter
                                  ? SplwTheme.primaryTeal
                                  : border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              filter,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: filter == _selectedFilter
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: filter == _selectedFilter
                                    ? Colors.white
                                    : textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: border),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: SplwTheme.softPrimaryOf(context),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.history,
                            size: 36,
                            color: SplwTheme.primaryTeal,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Belum ada aktivitas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tidak ada entri untuk filter ini.',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () =>
                              setState(() => _selectedFilter = 'Semua'),
                          child: const Text('Tampilkan Semua'),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (ctx, index) {
                      final log = filtered[index];
                      final dotColor = _getDotColor(log.action);

                      return InkWell(
                        key: Key('admin_log_${log.id}'),
                        onTap: () => _showLogDetail(log),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: dotColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: dotColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      actionLabel(log.action),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${log.userName} | ${log.ipAddress}',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formatTime(log.createdAt),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              'Log bersifat hanya-baca dan disimpan 180 hari (BR-17)\nKetuk entri untuk melihat detail',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
