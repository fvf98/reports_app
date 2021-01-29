import 'dart:convert';
import 'package:reports_app/models/api_response.dart';
import 'package:reports_app/models/issue_type.dart';
import 'package:reports_app/services/base_servide.dart';
import 'package:http/http.dart' as http;

class IssueTypeService extends BaseService {
  Future<APIResponse<List<IssueType>>> getIssueTypesList() {
    return http.get(api + '/issue', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final issues = <IssueType>[];
        for (var item in jsonData['data']) {
          issues.add(IssueType.fromJson(item));
        }
        return APIResponse<List<IssueType>>(data: issues);
      }
      return APIResponse<List<IssueType>>(
          error: true, message: 'An error occured');
    }).catchError((_) =>
        APIResponse<List<IssueType>>(error: true, message: 'An error occured'));
  }
}
