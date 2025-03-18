import 'package:frog_task_list/module/todo/domain/repository/todo_repository.dart';

class AddTodo {
  final TodoRepository repository;

  AddTodo(this.repository);

  Future<void> call(String title) async {
    await repository.addTodo(title);
  }
}
