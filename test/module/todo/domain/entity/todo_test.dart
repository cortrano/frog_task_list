import 'package:flutter_test/flutter_test.dart';
import 'package:frog_task_list/module/todo/domain/entity/todo_entity.dart';

void main() {
  group('TodoEntity Tests', () {
    test('TodoEntity creation test', () {
      final todo = TodoEntity(id: '1', title: 'Test Todo', completed: false);

      expect(todo.id, '1');
      expect(todo.title, 'Test Todo');
      expect(todo.completed, false);
    });

    test('TodoEntity equality test', () {
      final todo1 = TodoEntity(id: '1', title: 'Test Todo', completed: false);

      final todo2 = TodoEntity(id: '1', title: 'Test Todo', completed: false);

      expect(todo1, equals(todo2));
    });

    test('TodoEntity props test', () {
      final todo = TodoEntity(id: '1', title: 'Test Todo', completed: true);

      expect(todo.props, [todo.id, todo.title, todo.completed]);
    });
  });
}
