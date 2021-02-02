import 'package:json_annotation/json_annotation.dart';

part 'report_assign.g.dart';

@JsonSerializable()
class ReportAssign {
  num asigned;

  ReportAssign({this.asigned});

  factory ReportAssign.fromJson(Map<String, dynamic> item) =>
      _$ReportAssignFromJson(item);
  Map<String, dynamic> toJson() => _$ReportAssignToJson(this);
}
