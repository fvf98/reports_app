import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:reports_app/services/auth_service.dart';
import 'package:reports_app/services/report_service.dart';
import 'views/home_page.dart';

void setUpLocator() {
  GetIt.I.registerLazySingleton(() => AuthService());
  GetIt.I.registerLazySingleton(() => ReportService());
  GetIt.I.registerLazySingleton(() => FlutterSecureStorage());
}

void main() {
  setUpLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FIM cerca de ti',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          fontFamily: 'Nunito',
        ),
        home: HomePage());
  }
}
