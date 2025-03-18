import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@HiveType(typeId: 1)
abstract class User with _$User {
  const factory User({
    @HiveField(0) required String id,
    @HiveField(1) required String email,
    @HiveField(2) required String token,
    @HiveField(3) String? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
