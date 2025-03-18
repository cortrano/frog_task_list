import 'package:frog_task_list/core/index.dart';
import 'package:frog_task_list/module/auth/data/index.dart';

class AuthApi {
  final ApiClient client;

  AuthApi(this.client);

  Future<User> login(String email, String password) async {
    final response = await client.post('/auth/login', {
      'email': email,
      'password': password,
    });
    final token = response['token'] as String;
    return User(id: 'temp-id', email: email, token: token);
  }

  Future<User> register(String email, String password) async {
    await client.post('/auth/register', {'email': email, 'password': password});
    // После регистрации сразу логинимся
    return await login(email, password);
  }

  Future<bool> checkToken(String token) async {
    client.setToken(token);
    try {
      final response = await client.get('/auth/check');
      return response['valid'] as bool;
    } on TokenExpiredException {
      return false;
    }
  }
}
