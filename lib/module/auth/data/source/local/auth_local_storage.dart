import 'package:frog_task_list/module/auth/data/index.dart';

abstract class AuthLocalStorage {
  Future<void> init();
  Future<void> saveUser(User user);
  User? getUser();
  Future<void> clear();
}
