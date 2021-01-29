import 'package:json_annotation/json_annotation.dart';

part 'issue_type.g.dart';

@JsonSerializable()
class IssueType {
  num id;
  String title;

  IssueType({this.id, this.title});

  factory IssueType.fromJson(Map<String, dynamic> item) =>
      _$IssueTypeFromJson(item);

  Map<String, dynamic> toJson() => _$IssueTypeToJson(this);
}
