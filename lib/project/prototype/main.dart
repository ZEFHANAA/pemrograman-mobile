import 'package:flutter/material.dart';

import 'screens/account_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'screens/saved_screen.dart';
import 'state/splw_state.dart';
import 'theme/splw_theme.dart';

void main() {
  runApp(const SplwPrototypeApp());
}

class SplwPrototypeApp extends StatefulWidget {
  const SplwPrototypeApp({super.key});

  @override
  State<SplwPrototypeApp> createState() => _SplwPrototypeAppState();
}

class _SplwPrototypeAppState extends State<SplwPrototypeApp> {
  final SplwState _state = SplwState();
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _state.addListener(_onStateChange);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPLW Mobile - Prototype',
      debugShowCheckedModeBanner: false,
      themeMode: _state.themeMode,
      theme: SplwTheme.lightTheme,
      darkTheme: SplwTheme.darkTheme,
      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();
        final splash = _SplashScreen(
          onFinish: () => setState(() => _showSplash = false),
        );
        final width = MediaQuery.sizeOf(context).width;
        if (width < 600) {
          return Stack(
            children: [
              Positioned.fill(child: content),
              if (_showSplash) Positioned.fill(child: splash),
            ],
          );
        }
        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430, maxHeight: 920),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 30,
                    spreadRadius: 4,
                    offset: Offset(0, 10),
                  ),
                ],
                border: Border.all(color: const Color(0xFF334155), width: 6),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(child: content),
                  if (_showSplash) Positioned.fill(child: splash),
                ],
              ),
            ),
          ),
        );
      },
      home: SplwMainShell(state: _state),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  final VoidCallback onFinish;

  const _SplashScreen({required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFinish,
      child: Container(
        color: SplwTheme.primaryTeal,
        width: double.infinity,
        height: double.infinity,
        child: const Column(
          children: [
            Spacer(),
            SplwLogo(size: 90, color: Colors.white, ringColor: Colors.white70),
            SizedBox(height: 24),
            Text(
              'SPLW',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Cari dan simpan lokasi wisata',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Spacer(),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Memeriksa sesi...',
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class SplwMainShell extends StatefulWidget {
  final SplwState state;

  const SplwMainShell({super.key, required this.state});

  @override
  State<SplwMainShell> createState() => _SplwMainShellState();
}

class _SplwMainShellState extends State<SplwMainShell> {
  int _currentIndex = 0;

  void _navigateToLogin({bool register = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          state: widget.state,
          startInRegister: register,
          onLoginSuccess: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Selamat datang kembali, ${widget.state.currentUser?.name}!',
                ),
                backgroundColor: SplwTheme.successGreen,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.state.isAdmin;
    final screens = <Widget>[
      MapScreen(
        state: widget.state,
        onRequireLogin: () => _navigateToLogin(),
      ),
      SavedScreen(
        state: widget.state,
        onRequireLogin: () => _navigateToLogin(),
        onRequireRegister: () => _navigateToLogin(register: true),
        onNavigateToMap: () => setState(() => _currentIndex = 0),
      ),
      AccountScreen(
        state: widget.state,
        onNavigateToLogin: () => _navigateToLogin(),
      ),
      if (isAdmin) AdminScreen(state: widget.state),
    ];
    final safeIndex = _currentIndex < screens.length ? _currentIndex : 0;

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: SplwTheme.cardOf(context),
          border: Border(
            top: BorderSide(color: SplwTheme.borderOf(context), width: 1.2),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  index: 0,
                  activeIndex: safeIndex,
                  icon: Icons.location_on_outlined,
                  activeIcon: Icons.location_on,
                  label: 'Peta',
                  keyName: 'nav_peta',
                ),
                _buildNavItem(
                  context,
                  index: 1,
                  activeIndex: safeIndex,
                  icon: Icons.bookmark_border,
                  activeIcon: Icons.bookmark,
                  label: 'Tersimpan',
                  keyName: 'nav_tersimpan',
                ),
                _buildNavItem(
                  context,
                  index: 2,
                  activeIndex: safeIndex,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Akun',
                  keyName: 'nav_akun',
                ),
                if (isAdmin)
                  _buildNavItem(
                    context,
                    index: 3,
                    activeIndex: safeIndex,
                    icon: Icons.shield_outlined,
                    activeIcon: Icons.shield,
                    label: 'Admin',
                    keyName: 'nav_admin',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required int activeIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String keyName,
  }) {
    final isSelected = activeIndex == index;
    final color = isSelected
        ? SplwTheme.primaryTeal
        : SplwTheme.textSecondaryOf(context);

    return InkWell(
      key: Key(keyName),
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
