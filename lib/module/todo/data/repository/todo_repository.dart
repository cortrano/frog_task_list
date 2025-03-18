import 'package:frog_task_list/core/index.dart';
import 'package:frog_task_list/module/todo/data/index.dart';
import 'package:frog_task_list/module/todo/domain/index.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoApi api;
  final TodoLocalStorage local;

  TodoRepositoryImpl(this.api, this.local);

  @override
  Future<List<TodoEntity>> fetchTodos() async {
    try {
      final todos = await api.fetchTodos();
      await local.saveTodos(todos);
      return todos
          .map(
            (todo) => TodoEntity(
              id: todo.id,
              title: todo.title,
              completed: todo.completed,
            ),
          )
          .toList();
    } on TokenExpiredException {
      throw TokenExpiredException();
    } catch (e) {
      final cached = local.getTodos();
      if (cached.isNotEmpty) {
        return cached
            .map(
              (todo) => TodoEntity(
                id: todo.id,
                title: todo.title,
                completed: todo.completed,
              ),
            )
            .toList();
      }
      rethrow;
    }
  }

  @override
  Future<void> addTodo(String title) async {
    try {
      await api.addTodo(title);
      final todos = await fetchTodos();
      await local.saveTodos(
        todos
            .map((e) => Todo(id: e.id, title: e.title, completed: e.completed))
            .toList(),
      );
    } on TokenExpiredException {
      throw TokenExpiredException();
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await api.deleteTodo(id);
      final todos = await fetchTodos();
      await local.saveTodos(
        todos
            .map((e) => Todo(id: e.id, title: e.title, completed: e.completed))
            .toList(),
      );
    } on TokenExpiredException {
      throw TokenExpiredException();
    }
  }
}
