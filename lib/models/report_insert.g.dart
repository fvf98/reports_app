// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_insert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportInsert _$ReportInsertFromJson(Map<String, dynamic> json) {
  return ReportInsert(
    title: json['title'] as String,
    issueType: json['issueType'] as num,
    location: json['location'] as String,
    description: json['description'] as String,
    images: (json['images'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ReportInsertToJson(ReportInsert instance) =>
    <String, dynamic>{
      'title': instance.title,
      'issueType': instance.issueType,
      'location': instance.location,
      'description': instance.description,
      'images': instance.images,
    };
