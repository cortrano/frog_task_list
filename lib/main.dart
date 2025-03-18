import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frog_task_list/app_router.dart';
import 'package:frog_task_list/module/auth/data/index.dart';
import 'package:frog_task_list/shared/index.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'module/todo/data/index.dart'; // Для Hive

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TodoAdapter());

  // Инициализация локального хранилища напрямую
  final authLocal = HiveAuthLocal(); // Или SembastAuthLocal()
  final todoLocal = HiveTodoLocal(); // Или SembastTodoLocal()
  await authLocal.init();
  await todoLocal.init();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: 'ToDo App',
      theme: AppTheme.lightTheme,
    );
  }
}
