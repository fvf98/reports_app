// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) {
  return Report(
    id: json['id'] as num,
    title: json['title'] as String,
    location: json['location'] as String,
    description: json['description'] as String,
    images: (json['images'] as List)?.map((e) => e as String)?.toList(),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    issueType: json['issueType'] == null
        ? null
        : IssueType.fromJson(json['issueType'] as Map<String, dynamic>),
    asigned: json['asigned'] == null
        ? null
        : User.fromJson(json['asigned'] as Map<String, dynamic>),
    author: json['author'] == null
        ? null
        : User.fromJson(json['author'] as Map<String, dynamic>),
    status: json['status'] as String,
  );
}

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'location': instance.location,
      'description': instance.description,
      'images': instance.images,
      'createdAt': instance.createdAt?.toIso8601String(),
      'issueType': instance.issueType,
      'asigned': instance.asigned,
      'author': instance.author,
      'status': instance.status,
    };
