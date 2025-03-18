import 'package:frog_task_list/module/todo/domain/repository/todo_repository.dart';

class DeleteTodo {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<void> call(String id) async {
    await repository.deleteTodo(id);
  }
}
