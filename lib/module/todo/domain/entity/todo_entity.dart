import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final String id;
  final String title;
  final bool completed;

  const TodoEntity({
    required this.id,
    required this.title,
    this.completed = false,
  });

  @override
  List<Object> get props => [id, title, completed];
}
