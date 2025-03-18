import 'package:frog_task_list/module/auth/domain/index.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password);
  Future<void> logout();
  Future<bool> checkToken();
}
