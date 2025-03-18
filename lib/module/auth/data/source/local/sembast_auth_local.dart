import 'package:frog_task_list/module/auth/data/index.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

class SembastAuthLocal implements AuthLocalStorage {
  static const String dbName = 'auth.db';
  static const String storeName = 'auth';
  Database? _db;
  late StoreRef<String, Map<String, dynamic>> _store;

  @override
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = '${dir.path}/$dbName';
    _db = await databaseFactoryIo.openDatabase(dbPath);
    _store = stringMapStoreFactory.store(storeName);
  }

  @override
  Future<void> saveUser(User user) async {
    await _store.record('user').put(_db!, user.toJson());
  }

  @override
  User? getUser() {
    final data = _store.record('user').getSync(_db!);
    return data != null ? User.fromJson(data) : null;
  }

  @override
  Future<void> clear() async {
    await _store.record('user').delete(_db!);
  }
}
