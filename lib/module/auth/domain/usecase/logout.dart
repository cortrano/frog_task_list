import 'package:frog_task_list/module/auth/domain/index.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}
