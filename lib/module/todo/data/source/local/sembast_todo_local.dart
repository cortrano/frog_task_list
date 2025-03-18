import 'package:frog_task_list/module/todo/data/index.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

class SembastTodoLocal implements TodoLocalStorage {
  static const String dbName = 'todos.db';
  static const String storeName = 'todos';
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
  Future<void> saveTodos(List<Todo> todos) async {
    await _store.drop(_db!);
    for (var todo in todos) {
      await _store.record(todo.id).put(_db!, todo.toJson());
    }
  }

  @override
  List<Todo> getTodos() {
    final records = _store.findSync(_db!);
    return records.map((record) => Todo.fromJson(record.value)).toList();
  }
}
