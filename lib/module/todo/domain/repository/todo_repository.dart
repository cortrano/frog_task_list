import 'package:frog_task_list/module/todo/domain/index.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> fetchTodos();
  Future<void> addTodo(String title);
  Future<void> deleteTodo(String id);
}
