import 'package:flutter_test/flutter_test.dart';
import 'package:frog_task_list/module/todo/domain/entity/todo_entity.dart';
import 'package:frog_task_list/module/todo/domain/repository/todo_repository.dart';
import 'package:frog_task_list/module/todo/domain/usecase/fetch_todos.dart';

class MockTodoRepository implements TodoRepository {
  final List<TodoEntity> _todos = [];
  int fetchCount = 0;

  void addTodoForTest(String title) {
    _todos.add(TodoEntity(id: (_todos.length + 1).toString(), title: title));
  }

  @override
  Future<void> addTodo(String title) async {}

  @override
  Future<void> deleteTodo(String id) async {}

  @override
  Future<List<TodoEntity>> fetchTodos() async {
    fetchCount++;
    return _todos;
  }
}

void main() {
  group('FetchTodos UseCase', () {
    late FetchTodos useCase;
    late MockTodoRepository repository;

    setUp(() {
      repository = MockTodoRepository();
      useCase = FetchTodos(repository);
    });

    test('should return empty list when no todos', () async {
      final todos = await useCase();
      expect(todos, isEmpty);
      expect(repository.fetchCount, 1);
    });

    test('should return todos from repository', () async {
      repository.addTodoForTest('First Todo');
      repository.addTodoForTest('Second Todo');

      final todos = await useCase();

      expect(todos.length, 2);
      expect(todos[0].title, 'First Todo');
      expect(todos[1].title, 'Second Todo');
      expect(repository.fetchCount, 1);
    });

    test('should return todos sorted by id', () async {
      repository.addTodoForTest('First Todo');
      repository.addTodoForTest('Second Todo');
      repository.addTodoForTest('Third Todo');

      final todos = await useCase();

      expect(todos.map((e) => e.id).toList(), ['1', '2', '3']);
    });
  });
}
