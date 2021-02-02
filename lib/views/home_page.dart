import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';
import 'package:reports_app/models/api_response.dart';
import 'package:reports_app/models/report.dart';
import 'package:reports_app/services/report_service.dart';
import 'package:reports_app/views/confirm_alert.dart';
import 'package:reports_app/views/report_modify.dart';

import 'color_loader.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterSecureStorage get storage => GetIt.I<FlutterSecureStorage>();

  ReportService get service => GetIt.I<ReportService>();

  APIResponse<List<Report>> _apiResponse;
  List<Report> _reports = <Report>[];
  bool _isLoading = false;
  bool _isGroupLeader = true;
  num janitorId;
  String barTitle = 'Cargando...';

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} a las ${dateTime.hour}:${dateTime.minute}';
  }

  @override
  void initState() {
    _fetchReports('P');
    checkLoginStatus();
    super.initState();
  }

  _fetchReports(String satus) async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getReportsList();

    setState(() {
      _isLoading = false;
    });

    if (_isGroupLeader)
      _filterReports('All');
    else {
      String id = await storage.read(key: 'id');
      setState(() {
        janitorId = num.parse(id);
      });
      _filterReports(satus);
    }
  }

  _filterReports(String status) {
    setState(() {
      _isLoading = true;
    });

    if (_reports != null) _reports.clear();

    if (status != 'All') {
      if (status == 'P') {
        setState(() {
          barTitle = 'Reportes sin asignar';
        });
      } else if (status == 'T') {
        setState(() {
          barTitle = 'Mis reportes terminados';
        });
      } else if (status == 'A') {
        setState(() {
          barTitle = 'Mis reportes asignados';
        });
      }
      for (var item in _apiResponse.data) {
        if (status == 'P') {
          if (item.status == status) _reports.add(item);
        } else {
          if (item.status == status && item.asigned.id == janitorId)
            _reports.add(item);
        }
      }
    } else
      _reports = _apiResponse.data;

    setState(() {
      _isLoading = false;
    });
  }

  checkLoginStatus() async {
    String token = await storage.read(key: 'Token');
    if (token == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }

    String roles = await storage.read(key: 'roles');
    setState(() {
      _isGroupLeader = roles == 'Jefe de grupo' ? true : false;
    });
  }

  logOut() async {
    await storage.delete(key: 'Token');
    await storage.delete(key: 'id');
    await storage.delete(key: 'roles');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              _isGroupLeader ? 'Mis reportes' : barTitle,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue[800]),
        floatingActionButton: _isGroupLeader
            ? SpeedDial(
                marginRight: 18,
                marginBottom: 20,
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                visible: true,
                closeManually: false,
                curve: Curves.bounceIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                tooltip: 'Speed Dial',
                heroTag: 'speed-dial-hero-tag',
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.add),
                    backgroundColor: Colors.green[700],
                    label: 'Nuevo reporte',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => {
                      Navigator.of(context)
                          .push(
                              MaterialPageRoute(builder: (_) => ReportModify()))
                          .then((_) => _fetchReports('ALL'))
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.help_outline),
                    backgroundColor: Colors.white,
                    label: 'Ayuda',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => logOut(),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.exit_to_app),
                    backgroundColor: Colors.red[900],
                    label: 'Cerrar sesion',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => logOut(),
                  ),
                ],
              )
            : SpeedDial(
                marginRight: 18,
                marginBottom: 20,
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                visible: true,
                closeManually: false,
                curve: Curves.bounceIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                tooltip: 'Speed Dial',
                heroTag: 'speed-dial-hero-tag',
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.report_gmailerrorred_outlined),
                    backgroundColor: Colors.red[800],
                    label: 'Reportes sin asignar',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => _filterReports('P'),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.report_gmailerrorred_outlined),
                    backgroundColor: Colors.yellow[800],
                    label: 'Mis reportes asignados',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => _filterReports('A'),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.check),
                    backgroundColor: Colors.green[700],
                    label: 'Mis reportes terminados',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => _filterReports('T'),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.help_outline),
                    backgroundColor: Colors.white,
                    label: 'Ayuda',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => logOut(),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.exit_to_app),
                    backgroundColor: Colors.red[900],
                    label: 'Cerrar sesion',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => logOut(),
                  ),
                ],
              ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue,
                Colors.lightBlueAccent,
              ]),
            ),
            child: Builder(builder: (_) {
              if (_isLoading) {
                return Center(
                    child: Center(
                        child: ColorLoader(
                  radius: 25.0,
                  dotRadius: 10.0,
                )));
              }

              if (_apiResponse.error) {
                return Center(child: Text(_apiResponse.message));
              }

              return ListView.separated(
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.green),
                itemBuilder: (_, index) {
                  return Dismissible(
                    key: ValueKey(_reports[index].id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {},
                    confirmDismiss: (direction) async {
                      final result = await showDialog(
                          context: context,
                          builder: (_) => ConfirmAlert(
                              text:
                                  '¿Estas seguro de querer eliminar este reporte?'));

                      if (result) {
                        setState(() {
                          _isLoading = true;
                        });
                        final deleteResult = await service
                            .deleteReport(_reports[index].id.toString());
                        _getData();
                        var message;
                        var title;
                        if (deleteResult != null && deleteResult.data == true) {
                          title = 'Listo';
                          message = 'El reporte se elimino correctamente';
                        } else {
                          title = 'Error';
                          message = deleteResult?.message ?? 'An error occured';
                        }

                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text(title),
                                  content: Text(message),
                                  actions: <Widget>[
                                    FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })
                                  ],
                                ));

                        return deleteResult?.data ?? false;
                      }
                      print(result);
                      return result;
                    },
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.only(left: 16),
                      child: Align(
                        child: Icon(Icons.delete, color: Colors.white),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    child: ListTile(
                      leading: _reports[index].status == 'T'
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green[800],
                            )
                          : Icon(
                              Icons.report,
                              color: _reports[index].status == 'A'
                                  ? Colors.yellow[600]
                                  : Colors.red[900],
                            ),
                      title: Text(
                        _reports[index].title,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      subtitle: Text(
                          '''Problema de tipo: ${_reports[index].issueType.title}
Reportado el: ${formatDateTime(_reports[index].createdAt)}'''),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (_) => ReportModify(
                                      id: _reports[index].id.toString(),
                                      isJanitor: !_isGroupLeader,
                                    )))
                            .then((data) {
                          _getData();
                        });
                      },
                    ),
                  );
                },
                itemCount: _reports.length,
              );
            })),
      ),
      onRefresh: _getData,
    );
  }

  Future<void> _getData() async {
    String status;
    if (barTitle == 'Reportes sin asignar') status = 'P';
    if (barTitle == 'Mis reportes terminados') status = 'T';
    if (barTitle == 'Mis reportes asignados') status = 'A';
    setState(() {
      _fetchReports(status);
    });
  }
}
