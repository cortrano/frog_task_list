import 'package:frog_task_list/module/auth/domain/index.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<UserEntity> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
