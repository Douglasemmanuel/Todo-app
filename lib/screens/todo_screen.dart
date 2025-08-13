// lib/screens/todo_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_providers.dart';
import '../widgets/todo_item.dart';
import '../widgets/todo_stats.dart' as widgets;
import '../widgets/todo_filters.dart' as widgets;
import '../providers/theme_providers.dart';
import 'dart:async';


class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
   Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
     _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _addTodo(String title) {
    if (title.trim().isNotEmpty) {
      ref.read(todoListProvider.notifier).addTodo(title);
      _controller.clear();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(todoSearchQueryProvider.notifier).state = '';
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Update the provider only after user stops typing for 500ms
      ref.read(todoSearchQueryProvider.notifier).state = query;
    });
  }


  @override
  Widget build(BuildContext context) {
    final filteredTodos = ref.watch(filteredTodosProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Todo Showcase'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          )
        ],
      ),
      body: Column(
        children: [
     
          // Statistics section
          widgets.TodoStats(),

          // Filter section
          widgets.TodoFilters(),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search todos...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                ),
              ),
              onChanged: _onSearchChanged,
              
            ),
          ),

          // Add todo section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new todo...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _addTodo,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTodo(_controller.text),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          // Todo list
          Expanded(
            child: filteredTodos.isEmpty
                ? Center(
                    child: Text(
                      'No todos yet!\nAdd one above to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return TodoItem(todo: todo);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
