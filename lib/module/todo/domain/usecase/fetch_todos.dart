import 'package:frog_task_list/module/todo/domain/index.dart';

class FetchTodos {
  final TodoRepository repository;

  FetchTodos(this.repository);

  Future<List<TodoEntity>> call() async {
    return await repository.fetchTodos();
  }
}
