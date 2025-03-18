import 'package:frog_task_list/module/auth/data/index.dart';
import 'package:hive_ce/hive.dart';

class HiveAuthLocal implements AuthLocalStorage {
  static const String boxName = 'authBox';
  static const String userKey = 'user';

  @override
  Future<void> init() async {
    await Hive.openBox<User>(boxName);
  }

  @override
  Future<void> saveUser(User user) async {
    final box = Hive.box<User>(boxName);
    await box.put(userKey, user); // Сохраняем объект User напрямую
  }

  @override
  User? getUser() {
    final box = Hive.box<User>(boxName);
    return box.get(userKey);
  }

  @override
  Future<void> clear() async {
    final box = Hive.box<User>(boxName);
    await box.delete(userKey);
  }
}
