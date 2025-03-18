import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frog_task_list/module/todo/presentation/index.dart';
import 'package:frog_task_list/shared/index.dart';
import 'package:go_router/go_router.dart';

class TodoAddScreen extends ConsumerWidget {
  final _titleController = TextEditingController();

  TodoAddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить ToDo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: _titleController, label: 'Название'),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Сохранить',
              onPressed: () {
                ref
                    .read(todoViewModelProvider.notifier)
                    .addTodo(_titleController.text);
                context.go('/todos');
              },
            ),
          ],
        ),
      ),
    );
  }
}
