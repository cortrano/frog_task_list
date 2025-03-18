import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frog_task_list/module/auth/presentation/index.dart';
import 'package:frog_task_list/shared/index.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: authState.when(
          data:
              (user) =>
                  user != null
                      ? Column(
                        children: [
                          Text('Добро пожаловать, ${user.email}!'),
                          ElevatedButton(
                            onPressed: () => context.go('/todos'),
                            child: const Text('Перейти к ToDo'),
                          ),
                          ElevatedButton(
                            onPressed:
                                () =>
                                    ref
                                        .read(authViewModelProvider.notifier)
                                        .logout(),
                            child: const Text('Выйти'),
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
                                    .login(
                                      _emailController.text,
                                      _passwordController.text,
                                    ),
                            child: const Text('Войти'),
                          ),
                          TextButton(
                            onPressed: () => context.go('/register'),
                            child: const Text(
                              'Нет аккаунта? Зарегистрироваться',
                            ),
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
