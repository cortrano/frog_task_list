import 'package:frog_task_list/module/auth/domain/index.dart';

class CheckToken {
  final AuthRepository repository;

  CheckToken(this.repository);

  Future<bool> call() async {
    return await repository.checkToken();
  }
}
