// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/todo_screen.dart';
import '../providers/theme_providers.dart';
import '../preferences/theme_preferences.dart';
import '../providers/todo_providers.dart';
import '../preferences/todo_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load theme before app starts
  final savedTheme = await ThemePrefs.loadThemeMode();
  final savedTodos = await TodoPrefs.loadTodos(); 
  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith(
          (ref) => ThemeNotifier(savedTheme),
        ),
        todoListProvider.overrideWith(
          (ref) => TodoListNotifier(savedTodos),
        ),

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'Riverpod Todo Showcase',
      debugShowCheckedModeBanner: false,
       theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode, // dynamic theme switching
      home: TodoScreen(),
    );
  }
}
