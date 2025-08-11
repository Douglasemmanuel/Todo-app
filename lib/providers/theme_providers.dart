import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/todo_screen.dart';
import '../providers/theme_providers.dart';
import '../preferences/theme_preferences.dart';
class ThemeNotifier extends StateNotifier<ThemeMode> {

  ThemeNotifier(ThemeMode initialMode) : super(initialMode);



  Future<void> toggleTheme() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await ThemePrefs.saveThemeMode(state);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => throw UnimplementedError('Override themeProvider in main.dart'),
);
