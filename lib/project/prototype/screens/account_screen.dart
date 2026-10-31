import 'package:flutter/material.dart';

import '../state/splw_state.dart';
import '../theme/splw_theme.dart';
import 'network_error_screen.dart';

class AccountScreen extends StatelessWidget {
  final SplwState state;
  final VoidCallback onNavigateToLogin;

  const AccountScreen({
    super.key,
    required this.state,
    required this.onNavigateToLogin,
  });

  Future<void> _showEditProfileDialog(BuildContext context) async {
    final user = state.currentUser;
    if (user == null) return;
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    String? error;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Ubah Profil',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: const Key('profile_name'),
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                const SizedBox(height: 10),
                TextField(
                  key: const Key('profile_email'),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
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
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                key: const Key('profile_save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SplwTheme.primaryTeal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final message = state.updateProfile(
                    name: nameController.text,
                    email: emailController.text,
                  );
                  if (message != null) {
                    setDialogState(() => error = message);
                    return;
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil berhasil diperbarui.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );

    nameController.dispose();
    emailController.dispose();
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final oldPass = TextEditingController();
    final newPass = TextEditingController();
    final confirmPass = TextEditingController();
    String? error;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Ganti Password (BR-06)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Masukkan kata sandi lama dan baru (minimal 8 karakter):',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('old_password'),
                  controller: oldPass,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password Lama *',
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  key: const Key('new_password'),
                  controller: newPass,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password Baru (Min. 8 char) *',
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  key: const Key('confirm_new_password'),
                  controller: confirmPass,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Password Baru *',
                    isDense: true,
                  ),
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
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                key: const Key('change_password_save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SplwTheme.primaryTeal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final message = state.changePassword(
                    oldPassword: oldPass.text,
                    newPassword: newPass.text,
                    confirmPassword: confirmPass.text,
                  );
                  if (message != null) {
                    setDialogState(() => error = message);
                    return;
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password berhasil diperbarui.'),
                      backgroundColor: SplwTheme.successGreen,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );

    oldPass.dispose();
    newPass.dispose();
    confirmPass.dispose();
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Pilih Tema (FR-10, BR-12)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          _themeOption(context, 'Ikuti Sistem', ThemeMode.system),
          _themeOption(context, 'Terang (Light)', ThemeMode.light),
          _themeOption(context, 'Gelap (Dark)', ThemeMode.dark),
        ],
      ),
    );
  }

  Widget _themeOption(BuildContext context, String label, ThemeMode mode) {
    return ListTile(
      leading: Icon(
        state.themeMode == mode
            ? Icons.radio_button_checked
            : Icons.radio_button_unchecked,
        color: SplwTheme.primaryTeal,
      ),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      onTap: () {
        state.setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }

  String _getThemeLabel() {
    switch (state.themeMode) {
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
      case ThemeMode.system:
        return 'Ikuti Sistem';
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Keluar dari akun?'),
        content: const Text(
          'Anda dapat masuk kembali kapan saja. Data lokasi tetap tersimpan pada akun Anda.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SplwTheme.dangerRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      state.logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda telah keluar dari akun.')),
      );
    }
  }

  Future<void> _confirmResetDemo(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Reset data demo?'),
        content: const Text(
          'Seluruh perubahan pada sesi ini akan dikembalikan ke data awal. Anda akan keluar dari akun.',
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SplwTheme.dangerRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      state.resetDemoData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data demo dikembalikan ke kondisi awal.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = state.currentUser;
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Akun')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: SplwTheme.cardOf(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SplwTheme.borderOf(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.swap_horiz,
                        size: 16,
                        color: SplwTheme.primaryTeal,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Demo Role Switcher:',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDemoChip(
                          context,
                          label: 'Guest',
                          keyName: 'role_guest',
                          isSelected: user == null,
                          onTap: () => state.switchDemoRole('guest'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildDemoChip(
                          context,
                          label: 'User',
                          keyName: 'role_user',
                          isSelected: user?.role == 'user',
                          onTap: () => state.switchDemoRole('user'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildDemoChip(
                          context,
                          label: 'Admin',
                          keyName: 'role_admin',
                          isSelected: user?.role == 'admin',
                          onTap: () => state.switchDemoRole('admin'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: SplwTheme.softPrimaryOf(context),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                user != null
                    ? user.name
                        .split(' ')
                        .where((word) => word.isNotEmpty)
                        .map((word) => word[0])
                        .take(2)
                        .join()
                    : 'G',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: SplwTheme.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.name ?? 'Pengunjung (Tamu)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'Masuk untuk mengaktifkan akun',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
            const SizedBox(height: 24),
            if (user != null) ...[
              _buildMenuItem(
                context,
                keyName: 'account_edit_profile',
                title: 'Ubah Profil',
                onTap: () => _showEditProfileDialog(context),
              ),
              const SizedBox(height: 10),
              _buildMenuItem(
                context,
                keyName: 'account_change_password',
                title: 'Ganti Password',
                onTap: () => _showChangePasswordDialog(context),
              ),
              const SizedBox(height: 10),
            ],
            _buildMenuItem(
              context,
              keyName: 'account_theme',
              title: 'Tema',
              trailingText: _getThemeLabel(),
              onTap: () => _showThemeDialog(context),
            ),
            const SizedBox(height: 10),
            _buildMenuItem(
              context,
              keyName: 'account_clear_history',
              title: 'Hapus Riwayat Pencarian',
              onTap: () {
                state.clearSearchHistory();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Riwayat pencarian lokal berhasil dibersihkan (BR-12).',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            if (user != null)
              _buildMenuItem(
                context,
                keyName: 'account_logout',
                title: 'Keluar',
                titleColor: SplwTheme.dangerRed,
                onTap: () => _confirmLogout(context),
              )
            else
              _buildMenuItem(
                context,
                keyName: 'account_login',
                title: 'Masuk / Daftar Akun',
                titleColor: SplwTheme.primaryTeal,
                onTap: onNavigateToLogin,
              ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: SplwTheme.cardOf(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SplwTheme.borderOf(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alat demo',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Untuk memperlihatkan state yang tidak selalu muncul di alur normal.',
                    style: TextStyle(fontSize: 11, color: textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        key: const Key('demo_network_error'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NetworkErrorScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.cloud_off, size: 15),
                        label: const Text(
                          'Galat Jaringan',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      OutlinedButton.icon(
                        key: const Key('demo_reset_data'),
                        onPressed: () => _confirmResetDemo(context),
                        icon: const Icon(Icons.restart_alt, size: 15),
                        label: const Text(
                          'Reset Data',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Sesi dan data demo hanya tersimpan selama aplikasi berjalan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: SplwTheme.textMutedOf(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoChip(
    BuildContext context, {
    required String label,
    required String keyName,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      key: Key(keyName),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? SplwTheme.primaryTeal : SplwTheme.cardOf(context),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? SplwTheme.primaryTeal
                : SplwTheme.borderOf(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Colors.white
                : SplwTheme.textPrimaryOf(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String keyName,
    required String title,
    Color? titleColor,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      key: Key(keyName),
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
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: titleColor ?? SplwTheme.primaryTeal,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: titleColor ?? SplwTheme.textPrimaryOf(context),
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: TextStyle(
                  fontSize: 12,
                  color: SplwTheme.textMutedOf(context),
                ),
              ),
              const SizedBox(width: 6),
            ],
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
}
