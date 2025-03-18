import 'package:frog_task_list/module/todo/data/index.dart';

abstract class TodoLocalStorage {
  Future<void> init();
  Future<void> saveTodos(List<Todo> todos);
  List<Todo> getTodos();
}
