import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable()
class Auth {
  String userName;
  String password;

  Auth({this.userName, this.password});

  Map<String, dynamic> toJson() => _$AuthToJson(this);
}
