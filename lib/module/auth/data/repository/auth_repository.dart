import 'package:frog_task_list/core/index.dart';
import 'package:frog_task_list/module/auth/data/index.dart';
import 'package:frog_task_list/module/auth/domain/index.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;
  final AuthLocalStorage local;

  AuthRepositoryImpl(this.api, this.local);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final user = await api.login(email, password);
      await local.saveUser(user);
      api.client.setToken(user.token);
      return UserEntity(id: user.id, email: user.email, token: user.token);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to login: $e');
    }
  }

  @override
  Future<UserEntity> register(String email, String password) async {
    try {
      final user = await api.register(email, password);
      await local.saveUser(user);
      api.client.setToken(user.token);
      return UserEntity(id: user.id, email: user.email, token: user.token);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to register: $e');
    }
  }

  @override
  Future<void> logout() async {
    await local.clear();
    api.client.setToken(null);
  }

  @override
  Future<bool> checkToken() async {
    final user = local.getUser();
    if (user == null) return false;
    try {
      return await api.checkToken(user.token);
    } on TokenExpiredException {
      await logout();
      return false;
    } catch (e) {
      throw ServerException('Token check failed: $e');
    }
  }
}
