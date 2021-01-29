import 'package:json_annotation/json_annotation.dart';

part 'report_insert.g.dart';

@JsonSerializable()
class ReportInsert {
  String title;
  num issueType;
  String location;
  String description;
  List<String> images;

  ReportInsert(
      {this.title,
      this.issueType,
      this.location,
      this.description,
      this.images});

  factory ReportInsert.fromJson(Map<String, dynamic> item) =>
      _$ReportInsertFromJson(item);
  Map<String, dynamic> toJson() => _$ReportInsertToJson(this);
}
