import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  num id;
  String name;
  String lastName;
  String userName;
  String roles;
  bool status;

  User(
      {this.id,
      this.name,
      this.lastName,
      this.userName,
      this.roles,
      this.status});

  factory User.fromJson(Map<String, dynamic> item) => _$UserFromJson(item);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
