// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueType _$IssueTypeFromJson(Map<String, dynamic> json) {
  return IssueType(
    id: json['id'] as num,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$IssueTypeToJson(IssueType instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };
