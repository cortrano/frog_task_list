import 'package:flutter_test/flutter_test.dart';
import 'package:frog_task_list/module/todo/data/model/todo.dart';

void main() {
  group('Todo Model Tests', () {
    test('should create Todo instance with required fields', () {
      final todo = Todo(id: '1', title: 'Test Todo');

      expect(todo.id, '1');
      expect(todo.title, 'Test Todo');
      expect(todo.completed, false); // Default value
      expect(todo.updatedAt, null); // Optional field
    });

    test('should create Todo instance with all fields', () {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        completed: true,
        updatedAt: '2024-03-18',
      );

      expect(todo.id, '1');
      expect(todo.title, 'Test Todo');
      expect(todo.completed, true);
      expect(todo.updatedAt, '2024-03-18');
    });

    test('should create Todo from JSON', () {
      final json = {
        'id': '1',
        'title': 'Test Todo',
        'completed': true,
        'updatedAt': '2024-03-18',
      };

      final todo = Todo.fromJson(json);

      expect(todo.id, '1');
      expect(todo.title, 'Test Todo');
      expect(todo.completed, true);
      expect(todo.updatedAt, '2024-03-18');
    });

    test('should convert Todo to JSON', () {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        completed: true,
        updatedAt: '2024-03-18',
      );

      final json = todo.toJson();

      expect(json, {
        'id': '1',
        'title': 'Test Todo',
        'completed': true,
        'updatedAt': '2024-03-18',
      });
    });

    test('should copy Todo with new values', () {
      final todo = Todo(id: '1', title: 'Test Todo');

      final updatedTodo = todo.copyWith(
        completed: true,
        updatedAt: '2024-03-18',
      );

      expect(updatedTodo.id, '1'); // Unchanged
      expect(updatedTodo.title, 'Test Todo'); // Unchanged
      expect(updatedTodo.completed, true); // Updated
      expect(updatedTodo.updatedAt, '2024-03-18'); // Updated
    });
  });
}
