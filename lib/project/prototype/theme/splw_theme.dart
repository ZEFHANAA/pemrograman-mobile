import 'package:flutter/material.dart';

class SplwTheme {
  static const Color primaryTeal = Color(0xFF0F766E);
  static const Color primaryDark = Color(0xFF115E59);
  static const Color primaryLight = Color(0xFFE6F4F1);
  static const Color primaryContainer = Color(0xFFCCFBF1);

  static const Color surfaceBg = Color(0xFFF5F8F7);
  static const Color cardBg = Colors.white;
  static const Color borderColor = Color(0xFFE2E8F0);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color dangerRed = Color(0xFFDC2626);
  static const Color successGreen = Color(0xFF15803D);
  static const Color warningOrange = Color(0xFFD97706);

  static const Map<String, Color> categoryColors = {
    'Budaya': Color(0xFFC2410C),
    'Alam': Color(0xFF15803D),
    'Gunung': Color(0xFF78350F),
    'Pantai': Color(0xFF0284C7),
    'Kota': Color(0xFF7E22CE),
    'Kuliner': Color(0xFFDC2626),
    'Lainnya': Color(0xFF64748B),
  };

  static Color getCategoryColor(String kat) {
    return categoryColors[kat] ?? const Color(0xFF64748B);
  }

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color surfaceOf(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static Color cardOf(BuildContext context) =>
      isDark(context) ? const Color(0xFF1E293B) : Colors.white;

  static Color elevatedCardOf(BuildContext context) =>
      isDark(context) ? const Color(0xFF263449) : Colors.white;

  static Color textPrimaryOf(BuildContext context) =>
      isDark(context) ? const Color(0xFFF1F5F9) : textPrimary;

  static Color textSecondaryOf(BuildContext context) =>
      isDark(context) ? const Color(0xFFCBD5E1) : textSecondary;

  static Color textMutedOf(BuildContext context) =>
      isDark(context) ? const Color(0xFF94A3B8) : textMuted;

  static Color borderOf(BuildContext context) =>
      isDark(context) ? const Color(0xFF334155) : borderColor;

  static Color inputFillOf(BuildContext context) =>
      isDark(context) ? const Color(0xFF0B1220) : Colors.white;

  static Color softPrimaryOf(BuildContext context) =>
      isDark(context) ? const Color(0xFF134E4A) : const Color(0xFFE2EFEA);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: surfaceBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        primary: primaryTeal,
        secondary: primaryTeal,
        surface: surfaceBg,
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
          fontFamily: 'Roboto',
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: textMuted, fontSize: 13),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 12),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryTeal, width: 1.4),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        primary: primaryTeal,
        brightness: Brightness.dark,
        surface: const Color(0xFF0F172A),
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF134E4A),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0B1220),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        labelStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryTeal, width: 1.4),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF334155),
        thickness: 1,
      ),
    );
  }
}

class SplwLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final Color? ringColor;

  const SplwLogo({
    super.key,
    this.size = 64,
    this.color,
    this.ringColor,
  });

  @override
  Widget build(BuildContext context) {
    final teal = color ?? SplwTheme.primaryTeal;
    final ring = ringColor ?? teal;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ring, width: size * 0.1),
      ),
      alignment: Alignment.center,
      child: Container(
        width: size * 0.38,
        height: size * 0.38,
        decoration: BoxDecoration(
          color: teal,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
