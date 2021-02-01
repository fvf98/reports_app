import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:reports_app/models/api_response.dart';
import 'package:reports_app/models/auth.dart';
import 'package:reports_app/services/base_servide.dart';
import 'package:http/http.dart' as http;

class AuthService extends BaseService {
  FlutterSecureStorage get storage => GetIt.I<FlutterSecureStorage>();

  Future<APIResponse<bool>> login(Auth item) {
    return http
        .post(api + '/auth/login',
            headers: headers, body: json.encode(item.toJson()))
        .then((data) async {
      final jsonData = json.decode(data.body);
      if (data.statusCode == 201) {
        await storage.write(
          key: 'Token',
          value: jsonData['data']['accessToken'],
        );
        await storage.write(
          key: 'id',
          value: jsonData['data']['user']['id'].toString(),
        );
        await storage.write(
          key: 'roles',
          value: jsonData['data']['user']['roles'],
        );
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, message: jsonData['message']);
    }).catchError(
            (_) => APIResponse<bool>(error: true, message: 'An error occured'));
  }
}
