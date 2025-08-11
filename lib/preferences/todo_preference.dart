import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoPrefs {
  static const _key = 'todo_list';

  static Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  static Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Todo.fromJson(json)).toList();
  }
}
