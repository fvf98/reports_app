import 'dart:convert';
import 'package:reports_app/models/api_response.dart';
import 'package:reports_app/models/auth.dart';
import 'package:reports_app/services/base_servide.dart';
import 'package:http/http.dart' as http;

class AuthService extends BaseService {
  Future<APIResponse<bool>> login(Auth item) {
    return http
        .post(api + '/auth/login', headers: headers, body: json.encode(item))
        .then((data) {
      final jsonData = json.decode(data.body);
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, message: jsonData.message);
    }).catchError(
            (_) => APIResponse<bool>(error: true, message: 'An error occured'));
  }
}
