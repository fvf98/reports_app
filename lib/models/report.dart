import 'package:json_annotation/json_annotation.dart';
import 'package:reports_app/models/issue_type.dart';
import 'package:reports_app/models/user.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  num id;
  String title;
  String location;
  String description;
  List<String> images;
  DateTime createdAt;
  DateTime doneAt;
  IssueType issueType;
  User asigned;
  User author;
  String status;

  Report(
      {this.id,
      this.title,
      this.location,
      this.description,
      this.images,
      this.createdAt,
      this.doneAt,
      this.issueType,
      this.asigned,
      this.author,
      this.status});

  factory Report.fromJson(Map<String, dynamic> item) => _$ReportFromJson(item);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
