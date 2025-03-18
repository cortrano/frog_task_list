import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frog_task_list/module/auth/presentation/index.dart';
import 'package:frog_task_list/module/todo/presentation/index.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
      GoRoute(path: '/todos', builder: (context, state) => TodoListScreen()),
      GoRoute(path: '/todos/add', builder: (context, state) => TodoAddScreen()),
    ],
    redirect: (context, state) {
      final user = ref.read(authViewModelProvider).value;
      final currentPath = state.uri.toString();
      if (user == null && currentPath != '/' && currentPath != '/register')
        return '/';
      if (user != null && (currentPath == '/' || currentPath == '/register'))
        return '/todos';
      return null;
    },
  );
});
