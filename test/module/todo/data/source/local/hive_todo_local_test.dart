import 'package:flutter_test/flutter_test.dart';
import 'package:frog_task_list/module/todo/data/model/todo.dart';
import 'package:frog_task_list/module/todo/data/source/local/hive_todo_local.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  group('HiveTodoLocal Tests', () {
    late HiveTodoLocal storage;
    late Directory tempDir;

    setUp(() async {
      // Создаем временную директорию для тестов
      tempDir = await Directory.systemTemp.createTemp();

      // Инициализируем Hive с временной директорией
      Hive.init(tempDir.path);

      // Регистрируем адаптер для Todo
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TodoAdapter());
      }

      storage = HiveTodoLocal();
      await storage.init();
    });

    tearDown(() async {
      // Закрываем все боксы
      await Hive.close();
      // Удаляем временную директорию
      await tempDir.delete(recursive: true);
    });

    test('should start with empty storage', () {
      final todos = storage.getTodos();
      expect(todos, isEmpty);
    });

    test('should save and retrieve todos', () async {
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

    test('should persist data between storage instances', () async {
      // Сохраняем данные в первом экземпляре
      final todos = [
        Todo(id: '1', title: 'First Todo'),
        Todo(id: '2', title: 'Second Todo'),
      ];
      await storage.saveTodos(todos);

      // Создаем новый экземпляр хранилища
      final newStorage = HiveTodoLocal();
      await newStorage.init();

      // Проверяем, что данные сохранились
      final storedTodos = newStorage.getTodos();
      expect(storedTodos.length, 2);
      expect(storedTodos.map((e) => e.title).toList(), [
        'First Todo',
        'Second Todo',
      ]);
    });

    test('should handle todos with all fields', () async {
      final now = DateTime.now().toIso8601String();
      final todos = [
        Todo(id: '1', title: 'Complete Todo', completed: true, updatedAt: now),
      ];

      await storage.saveTodos(todos);
      final storedTodos = storage.getTodos();

      expect(storedTodos.length, 1);
      expect(storedTodos.first.id, '1');
      expect(storedTodos.first.title, 'Complete Todo');
      expect(storedTodos.first.completed, true);
      expect(storedTodos.first.updatedAt, now);
    });

    test('should handle empty list', () async {
      await storage.saveTodos([]);
      final todos = storage.getTodos();
      expect(todos, isEmpty);
    });

    test('should handle large number of todos', () async {
      final largeTodoList = List.generate(
        100,
        (index) => Todo(id: index.toString(), title: 'Todo $index'),
      );

      await storage.saveTodos(largeTodoList);
      final storedTodos = storage.getTodos();

      expect(storedTodos.length, 100);
      expect(storedTodos.first.id, '0');
      expect(storedTodos.last.id, '99');
    });
  });
}
