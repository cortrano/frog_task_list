import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
@HiveType(typeId: 0)
abstract class Todo with _$Todo {
  const factory Todo({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) @Default(false) bool completed,
    @HiveField(3) String? updatedAt,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
