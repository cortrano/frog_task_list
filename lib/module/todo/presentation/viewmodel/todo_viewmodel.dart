import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frog_task_list/global_providers.dart';
import 'package:frog_task_list/module/todo/domain/index.dart'; // Barrel для domain

final todoViewModelProvider =
    StateNotifierProvider<TodoViewModel, AsyncValue<List<TodoEntity>>>((ref) {
      return TodoViewModel(ref);
    });

class TodoViewModel extends StateNotifier<AsyncValue<List<TodoEntity>>> {
  final Ref ref;

  TodoViewModel(this.ref) : super(const AsyncValue.loading()) {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    state = const AsyncValue.loading();
    try {
      final todos = await ref.read(fetchTodosProvider).call();
      state = AsyncValue.data(todos);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTodo(String title) async {
    try {
      await ref.read(addTodoProvider).call(title);
      await fetchTodos();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await ref.read(deleteTodoProvider).call(id);
      await fetchTodos();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
