import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frog_task_list/module/todo/presentation/index.dart';
import 'package:frog_task_list/shared/index.dart';
import 'package:go_router/go_router.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ToDo List')),
      body: todoState.when(
        data:
            (todos) => ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed:
                        () => ref
                            .read(todoViewModelProvider.notifier)
                            .deleteTodo(todo.id),
                  ),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Ошибка: $error')),
      ),
      floatingActionButton: CustomButton(
        text: 'Добавить',
        onPressed: () => context.go('/todos/add'),
      ),
    );
  }
}
