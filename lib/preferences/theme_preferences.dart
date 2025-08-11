import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePrefs {
  static const String _key = 'theme_mode';

  /// Save the current theme mode to SharedPreferences
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, mode.index);
  }

  /// Load the saved theme mode from SharedPreferences
  static Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_key);
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      return ThemeMode.values[index];
    }
    return ThemeMode.light; // default
  }
}
