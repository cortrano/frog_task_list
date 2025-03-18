import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frog_task_list/core/index.dart';

import 'module/auth/data/index.dart';
import 'module/auth/domain/index.dart';
import 'module/todo/data/index.dart';
import 'module/todo/domain/index.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final authApiProvider = Provider((ref) => AuthApi(ref.read(apiClientProvider)));
final authLocalProvider = Provider<AuthLocalStorage>((ref) => HiveAuthLocal());
final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(
    ref.read(authApiProvider),
    ref.read(authLocalProvider),
  ),
);
final loginProvider = Provider(
  (ref) => Login(ref.read(authRepositoryProvider)),
);
final registerProvider = Provider(
  (ref) => Register(ref.read(authRepositoryProvider)),
); // Новый провайдер
final logoutProvider = Provider(
  (ref) => Logout(ref.read(authRepositoryProvider)),
);
final checkTokenProvider = Provider(
  (ref) => CheckToken(ref.read(authRepositoryProvider)),
);

final todoApiProvider = Provider((ref) => TodoApi(ref.read(apiClientProvider)));
final todoLocalProvider = Provider<TodoLocalStorage>((ref) => HiveTodoLocal());
final todoRepositoryProvider = Provider(
  (ref) => TodoRepositoryImpl(
    ref.read(todoApiProvider),
    ref.read(todoLocalProvider),
  ),
);
final fetchTodosProvider = Provider(
  (ref) => FetchTodos(ref.read(todoRepositoryProvider)),
);
final addTodoProvider = Provider(
  (ref) => AddTodo(ref.read(todoRepositoryProvider)),
);
final deleteTodoProvider = Provider(
  (ref) => DeleteTodo(ref.read(todoRepositoryProvider)),
);
