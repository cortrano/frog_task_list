import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frog_task_list/module/auth/presentation/index.dart';
import 'package:frog_task_list/shared/index.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: authState.when(
          data:
              (user) =>
                  user != null
                      ? Column(
                        children: [
                          Text('Уже зарегистрирован как ${user.email}'),
                          ElevatedButton(
                            onPressed: () => context.go('/todos'),
                            child: const Text('Перейти к ToDo'),
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Пароль',
                            isPassword: true,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed:
                                () => ref
                                    .read(authViewModelProvider.notifier)
                                    .register(
                                      _emailController.text,
                                      _passwordController.text,
                                    ),
                            child: const Text('Зарегистрироваться'),
                          ),
                          TextButton(
                            onPressed: () => context.go('/'),
                            child: const Text('Уже есть аккаунт? Войти'),
                          ),
                        ],
                      ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Ошибка: $error')),
        ),
      ),
    );
  }
}
