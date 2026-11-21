import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeController {
  AppThemeController._();
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);
  static final ValueNotifier<Color> seed = ValueNotifier(Colors.teal);
  static final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  static Future<void> load() async {
    final dark = await _preferences.getBool('tabungku_dark_mode') ?? false;
    final color = await _preferences.getInt('tabungku_color_seed') ?? Colors.teal.toARGB32();
    mode.value = dark ? ThemeMode.dark : ThemeMode.light;
    seed.value = Color(color);
  }

  static Future<void> setDark(bool enabled) async {
    mode.value = enabled ? ThemeMode.dark : ThemeMode.light;
    await _preferences.setBool('tabungku_dark_mode', enabled);
  }

  static Future<void> toggle() => setDark(mode.value != ThemeMode.dark);

  static Future<void> setSeed(Color color) async {
    seed.value = color;
    await _preferences.setInt('tabungku_color_seed', color.toARGB32());
  }
}
