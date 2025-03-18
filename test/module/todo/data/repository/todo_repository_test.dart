import 'package:flutter_test/flutter_test.dart';
import 'package:frog_task_list/core/index.dart';
import 'package:frog_task_list/module/todo/data/index.dart';
import 'package:frog_task_list/module/todo/data/repository/todo_repository.dart';
import 'package:frog_task_list/module/todo/domain/entity/todo_entity.dart';

class MockApiClient extends ApiClient {
  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    return {'data': []};
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return {'success': true};
  }

  @override
  Future<void> delete(String endpoint) async {}
}

class MockTodoApi implements TodoApi {
  final List<Todo> _todos = [];
  bool shouldThrow = false;
  bool shouldThrowTokenExpired = false;

  @override
  ApiClient get client => MockApiClient();

  @override
  Future<List<Todo>> fetchTodos() async {
    if (shouldThrowTokenExpired) {
      throw TokenExpiredException();
    }
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return _todos;
  }

  @override
  Future<void> addTodo(String title) async {
    if (shouldThrowTokenExpired) {
      throw TokenExpiredException();
    }
    if (shouldThrow) {
      throw Exception('Network error');
    }
    _todos.add(Todo(id: (_todos.length + 1).toString(), title: title));
  }

  @override
  Future<void> deleteTodo(String id) async {
    if (shouldThrowTokenExpired) {
      throw TokenExpiredException();
    }
    if (shouldThrow) {
      throw Exception('Network error');
    }
    _todos.removeWhere((todo) => todo.id == id);
  }
}

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
}

void main() {
  group('TodoRepositoryImpl Tests', () {
    late TodoRepositoryImpl repository;
    late MockTodoApi api;
    late MockTodoLocalStorage localStorage;

    setUp(() async {
      api = MockTodoApi();
      localStorage = MockTodoLocalStorage();
      await localStorage.init();
      repository = TodoRepositoryImpl(api, localStorage);
    });

    test('fetchTodos should return data from API and cache it', () async {
      // Подготавливаем данные в API
      await api.addTodo('First Todo');
      await api.addTodo('Second Todo');

      // Получаем данные через репозиторий
      final todos = await repository.fetchTodos();

      // Проверяем полученные данные
      expect(todos.length, 2);
      expect(todos[0].title, 'First Todo');
      expect(todos[1].title, 'Second Todo');

      // Проверяем, что данные закэшировались
      final cachedTodos = localStorage.getTodos();
      expect(cachedTodos.length, 2);
      expect(cachedTodos[0].title, 'First Todo');
      expect(cachedTodos[1].title, 'Second Todo');
    });

    test('fetchTodos should return cached data when API fails', () async {
      // Сначала получаем и кэшируем данные
      await api.addTodo('Cached Todo');
      await repository.fetchTodos();

      // Симулируем ошибку API
      api.shouldThrow = true;

      // Должны получить закэшированные данные
      final todos = await repository.fetchTodos();
      expect(todos.length, 1);
      expect(todos[0].title, 'Cached Todo');
    });

    test('fetchTodos should throw TokenExpiredException', () async {
      api.shouldThrowTokenExpired = true;

      expect(
        () => repository.fetchTodos(),
        throwsA(isA<TokenExpiredException>()),
      );
    });

    test('addTodo should add todo and update cache', () async {
      await repository.addTodo('New Todo');

      // Проверяем API
      final apiTodos = await api.fetchTodos();
      expect(apiTodos.length, 1);
      expect(apiTodos[0].title, 'New Todo');

      // Проверяем кэш
      final cachedTodos = localStorage.getTodos();
      expect(cachedTodos.length, 1);
      expect(cachedTodos[0].title, 'New Todo');
    });

    test('deleteTodo should remove todo and update cache', () async {
      // Добавляем задачи
      await repository.addTodo('Todo 1');
      await repository.addTodo('Todo 2');

      // Удаляем первую задачу
      await repository.deleteTodo('1');

      // Проверяем API
      final apiTodos = await api.fetchTodos();
      expect(apiTodos.length, 1);
      expect(apiTodos[0].title, 'Todo 2');

      // Проверяем кэш
      final cachedTodos = localStorage.getTodos();
      expect(cachedTodos.length, 1);
      expect(cachedTodos[0].title, 'Todo 2');
    });

    test('should handle empty API response', () async {
      final todos = await repository.fetchTodos();
      expect(todos, isEmpty);
    });

    test('should throw when API fails and no cache available', () async {
      api.shouldThrow = true;

      expect(() => repository.fetchTodos(), throwsA(isA<Exception>()));
    });

    test('addTodo should throw TokenExpiredException', () async {
      api.shouldThrowTokenExpired = true;

      expect(
        () => repository.addTodo('New Todo'),
        throwsA(isA<TokenExpiredException>()),
      );
    });

    test('deleteTodo should throw TokenExpiredException', () async {
      api.shouldThrowTokenExpired = true;

      expect(
        () => repository.deleteTodo('1'),
        throwsA(isA<TokenExpiredException>()),
      );
    });
  });
}
