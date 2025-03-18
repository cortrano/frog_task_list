import 'package:flutter_test/flutter_test.dart';
import 'package:frog_task_list/module/todo/data/model/todo.dart';
import 'package:frog_task_list/module/todo/data/source/local/todo_local_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

class MockTodoLocalStorage implements TodoLocalStorage {
  final List<Todo> _todos = [];
  bool _initialized = false;

  @override
  Future<void> init() async {
    _initialized = true;
  }

  @override
  List<Todo> getTodos() {
    if (!_initialized) throw StateError('Storage not initialized');
    return _todos;
  }

  @override
  Future<void> saveTodos(List<Todo> todos) async {
    if (!_initialized) throw StateError('Storage not initialized');
    _todos.clear();
    _todos.addAll(todos);
  }

  @override
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
    }
  }
}

void main() {
  group('Todo Local Storage Tests', () {
    late MockTodoLocalStorage storage;

    setUp(() async {
      storage = MockTodoLocalStorage();
      await storage.init();
    });

    test('should start with empty storage', () {
      final todos = storage.getTodos();
      expect(todos, isEmpty);
    });

    test('should save todos', () async {
      final todos = [
        Todo(id: '1', title: 'First Todo'),
        Todo(id: '2', title: 'Second Todo'),
      ];

      await storage.saveTodos(todos);
      final storedTodos = storage.getTodos();

      expect(storedTodos.length, 2);
      expect(storedTodos[0].id, '1');
      expect(storedTodos[0].title, 'First Todo');
      expect(storedTodos[1].id, '2');
      expect(storedTodos[1].title, 'Second Todo');
    });

    test('should replace existing todos when saving', () async {
      final initialTodos = [Todo(id: '1', title: 'First Todo')];

      await storage.saveTodos(initialTodos);

      final newTodos = [
        Todo(id: '2', title: 'Second Todo'),
        Todo(id: '3', title: 'Third Todo'),
      ];

      await storage.saveTodos(newTodos);
      final storedTodos = storage.getTodos();

      expect(storedTodos.length, 2);
      expect(storedTodos.map((e) => e.id).toList(), ['2', '3']);
    });

    test('should throw error if not initialized', () {
      final uninitializedStorage = MockTodoLocalStorage();

      expect(() => uninitializedStorage.getTodos(), throwsStateError);
      expect(() => uninitializedStorage.saveTodos([]), throwsStateError);
    });

    test('should delete todo', () async {
      final todo = Todo(id: '1', title: 'Test Todo');

      await storage.saveTodos([todo]);
      await storage.deleteTodo('1');
      final todos = storage.getTodos();

      expect(todos, isEmpty);
    });

    test('should update todo', () async {
      final todo = Todo(id: '1', title: 'Test Todo', completed: false);

      await storage.saveTodos([todo]);

      final updatedTodo = todo.copyWith(
        completed: true,
        updatedAt: '2024-03-18',
      );

      await storage.updateTodo(updatedTodo);
      final todos = storage.getTodos();

      expect(todos.length, 1);
      expect(todos.first.completed, true);
      expect(todos.first.updatedAt, '2024-03-18');
    });

    test('should handle multiple todos', () async {
      final todos = [
        Todo(id: '1', title: 'First Todo'),
        Todo(id: '2', title: 'Second Todo'),
        Todo(id: '3', title: 'Third Todo'),
      ];

      await storage.saveTodos(todos);
      final storedTodos = storage.getTodos();
      expect(storedTodos.length, 3);
      expect(storedTodos.map((e) => e.title).toList(), [
        'First Todo',
        'Second Todo',
        'Third Todo',
      ]);
    });
  });
}
