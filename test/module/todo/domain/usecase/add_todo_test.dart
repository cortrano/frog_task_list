import 'package:flutter_test/flutter_test.dart';
import 'package:frog_task_list/module/todo/domain/entity/todo_entity.dart';
import 'package:frog_task_list/module/todo/domain/repository/todo_repository.dart';
import 'package:frog_task_list/module/todo/domain/usecase/add_todo.dart';

class MockTodoRepository implements TodoRepository {
  final List<String> addedTitles = [];

  @override
  Future<void> addTodo(String title) async {
    addedTitles.add(title);
  }

  @override
  Future<void> deleteTodo(String id) async {}

  @override
  Future<List<TodoEntity>> fetchTodos() async {
    return [];
  }
}

void main() {
  group('AddTodo UseCase', () {
    late AddTodo useCase;
    late MockTodoRepository repository;

    setUp(() {
      repository = MockTodoRepository();
      useCase = AddTodo(repository);
    });

    test('should add todo to repository', () async {
      const title = 'New Todo';
      await useCase(title);

      expect(repository.addedTitles, contains(title));
      expect(repository.addedTitles.length, 1);
    });

    test('should not accept empty title', () async {
      expect(() => useCase(''), throwsA(isA<ArgumentError>()));
    });

    test('should trim title', () async {
      await useCase('  Test Todo  ');
      expect(repository.addedTitles.first, 'Test Todo');
    });
  });
}
