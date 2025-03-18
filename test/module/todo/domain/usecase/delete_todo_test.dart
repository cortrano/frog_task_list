import 'package:flutter_test/flutter_test.dart';
import 'package:frog_task_list/module/todo/domain/entity/todo_entity.dart';
import 'package:frog_task_list/module/todo/domain/repository/todo_repository.dart';
import 'package:frog_task_list/module/todo/domain/usecase/delete_todo.dart';

class MockTodoRepository implements TodoRepository {
  final List<String> deletedIds = [];

  @override
  Future<void> addTodo(String title) async {}

  @override
  Future<void> deleteTodo(String id) async {
    deletedIds.add(id);
  }

  @override
  Future<List<TodoEntity>> fetchTodos() async {
    return [];
  }
}

void main() {
  group('DeleteTodo UseCase', () {
    late DeleteTodo useCase;
    late MockTodoRepository repository;

    setUp(() {
      repository = MockTodoRepository();
      useCase = DeleteTodo(repository);
    });

    test('should delete todo from repository', () async {
      const id = '1';
      await useCase(id);

      expect(repository.deletedIds, contains(id));
      expect(repository.deletedIds.length, 1);
    });

    test('should not accept empty id', () async {
      expect(() => useCase(''), throwsA(isA<ArgumentError>()));
    });

    test('should trim id', () async {
      await useCase('  123  ');
      expect(repository.deletedIds.first, '123');
    });
  });
}
