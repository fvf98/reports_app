// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as num,
    name: json['name'] as String,
    lastName: json['lastName'] as String,
    userName: json['userName'] as String,
    roles: json['roles'] as String,
    status: json['status'] as bool,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lastName': instance.lastName,
      'userName': instance.userName,
      'roles': instance.roles,
      'status': instance.status,
    };
