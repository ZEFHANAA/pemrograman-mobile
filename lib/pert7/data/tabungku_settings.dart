import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme_controller.dart';

class TabungKuSettings {
  TabungKuSettings._();
  static final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  static Future<int> getTarget() async => await _preferences.getInt('tabungku_target') ?? 20000;
  static Future<void> setTarget(int value) => _preferences.setInt('tabungku_target', value);

  static Future<void> setDarkMode(bool enabled) async {
    await _preferences.setBool('tabungku_dark_mode', enabled);
    await AppThemeController.setDark(enabled);
  }

  static Future<bool> getDarkMode() async => await _preferences.getBool('tabungku_dark_mode') ?? false;

  static Future<void> setColorSeed(int value) async {
    await _preferences.setInt('tabungku_color_seed', value);
    await AppThemeController.setSeed(Color(value));
  }

  static Future<int> getColorSeed() async => await _preferences.getInt('tabungku_color_seed') ?? Colors.teal.toARGB32();
}
