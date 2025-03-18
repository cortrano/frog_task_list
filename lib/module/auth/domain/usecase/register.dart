import 'package:frog_task_list/module/auth/domain/index.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<UserEntity> call(String email, String password) async {
    return await repository.register(email, password);
  }
}
