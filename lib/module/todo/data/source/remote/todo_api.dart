import 'package:frog_task_list/core/index.dart';
import 'package:frog_task_list/module/todo/data/index.dart';

class TodoApi {
  final ApiClient client;

  TodoApi(this.client);

  Future<List<Todo>> fetchTodos() async {
    final response = await client.get('/todos');
    final todos =
        (response['todos'] as List)
            .map((json) => Todo.fromJson(json as Map<String, dynamic>))
            .toList();
    return todos;
  }

  Future<void> addTodo(String title) async {
    await client.post('/todos', {'title': title});
  }

  Future<void> deleteTodo(String id) async {
    await client.delete('/todos/$id');
  }
}
