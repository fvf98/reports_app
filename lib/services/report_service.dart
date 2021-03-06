import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:reports_app/models/api_response.dart';
import 'package:reports_app/models/report.dart';
import 'package:reports_app/models/report_assign.dart';
import 'package:reports_app/models/report_insert.dart';
import 'package:reports_app/services/base_servide.dart';
import 'package:http/http.dart' as http;

class ReportService extends BaseService {
  FlutterSecureStorage get storage => GetIt.I<FlutterSecureStorage>();

  Future<APIResponse<List<Report>>> getReportsList() async {
    String roles = await storage.read(key: 'roles');
    String id = await storage.read(key: 'id');
    String url;
    if (roles == 'Jefe de grupo') {
      url = api + '/report/user/' + id;
    } else
      url = api + '/report';
    return http.get(url, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final reports = <Report>[];
        //Aqui peta
        for (var item in jsonData['data']) {
          reports.add(Report.fromJson(item));
        }
        return APIResponse<List<Report>>(data: reports);
      }
      return APIResponse<List<Report>>(
          error: true, message: 'Ha ocurrido un error');
    }).catchError((_) => APIResponse<List<Report>>(
        error: true, message: 'Ha ocurrido un error'));
  }

  Future<APIResponse<Report>> getReport(String id) {
    return http.get(api + '/report/' + id, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Report>(data: Report.fromJson(jsonData['data']));
      }
      return APIResponse<Report>(error: true, message: 'Ha ocurrido un error');
    }).catchError((_) =>
        APIResponse<Report>(error: true, message: 'Ha ocurrido un error'));
  }

  Future<APIResponse<bool>> finishReport(String id) async {
    String token = await storage.read(key: 'Token');
    return http.get(
      api + '/report/finish/' + id,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    ).then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, message: 'Ha ocurrido un error');
    }).catchError(
        (_) => APIResponse<bool>(error: true, message: 'Ha ocurrido un error'));
  }

  Future<APIResponse<bool>> createReport(ReportInsert item) async {
    String token = await storage.read(key: 'Token');
    return http
        .post(api + '/report/',
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, message: 'Ha ocurrido un error');
    }).catchError((_) =>
            APIResponse<bool>(error: true, message: 'Ha ocurrido un error'));
  }

  Future<APIResponse<bool>> updateReport(String id, ReportInsert item) async {
    String token = await storage.read(key: 'Token');
    return http
        .put(api + '/report/' + id,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, message: 'Ha ocurrido un error');
    }).catchError((_) =>
            APIResponse<bool>(error: true, message: 'Ha ocurrido un error'));
  }

  Future<APIResponse<bool>> assignReport(String id, ReportAssign item) async {
    String token = await storage.read(key: 'Token');
    return http
        .put(api + '/report/assign/' + id,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, message: 'Ha ocurrido un error');
    }).catchError((_) =>
            APIResponse<bool>(error: true, message: 'Ha ocurrido un error'));
  }

  Future<APIResponse<bool>> deleteReport(String id) async {
    String token = await storage.read(key: 'Token');
    return http.delete(api + '/report/' + id, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, message: 'Ha ocurrido un error');
    }).catchError(
        (_) => APIResponse<bool>(error: true, message: 'Ha ocurrido un error'));
  }
}
