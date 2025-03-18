import 'package:frog_task_list/module/todo/data/index.dart';
import 'package:hive_ce/hive.dart';

class HiveTodoLocal implements TodoLocalStorage {
  static const String boxName = 'todoBox';

  @override
  Future<void> init() async {
    await Hive.openBox<Todo>(boxName);
  }

  @override
  Future<void> saveTodos(List<Todo> todos) async {
    final box = Hive.box<Todo>(boxName);
    await box.clear();
    await box.addAll(todos);
  }

  @override
  List<Todo> getTodos() {
    final box = Hive.box<Todo>(boxName);
    return box.values.toList();
  }
}

// import 'package:hive/hive.dart';
// import 'package:flutter_mvvm_riverpod_clean/module/todo/data/model/todo.dart';
// import 'todo_local_storage.dart';

// class HiveTodoLocal implements TodoLocalStorage {
//   static const String boxName = 'todoBox';

//   @override
//   Future<void> init() async {
//     await Hive.openBox<Todo>(boxName);
//   }

//   @override
//   Future<void> saveTodos(List<Todo> todos) async {
//     final box = Hive.box<Todo>(boxName);
//     await box.clear();
//     for (var todo in todos) {
//       await box.put(todo.id, todo); // Сохраняем по ключу id
//     }
//   }

//   @override
//   List<Todo> getTodos() {
//     final box = Hive.box<Todo>(boxName);
//     return box.values.toList();
//   }
// }
