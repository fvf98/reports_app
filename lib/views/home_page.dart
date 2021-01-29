import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:reports_app/models/api_response.dart';
import 'package:reports_app/models/report.dart';
import 'package:reports_app/services/report_service.dart';
import 'package:reports_app/views/report_delete.dart';

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
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} a las ${dateTime.hour}:${dateTime.minute}';
  }

  @override
  void initState() {
    _fetchReports();
    checkLoginStatus();
    super.initState();
  }

  _fetchReports() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getReportsList();

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
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Reportes',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue[800]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[800],
          onPressed: () {
            /* Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NoteModify()))
              .then((_) {
            _fetchNotes();
          }); */
          },
          child: Icon(Icons.add, color: Colors.white),
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
                    key: ValueKey(_apiResponse.data[index].id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {},
                    confirmDismiss: (direction) async {
                      final result = await showDialog(
                          context: context, builder: (_) => ReportDelete());

                      if (result) {
                        setState(() {
                          _isLoading = true;
                        });
                        final deleteResult = await service.deleteReport(
                            _apiResponse.data[index].id.toString());
                        _fetchReports();
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
                      leading: _apiResponse.data[index].status == 'T'
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green[800],
                            )
                          : Icon(
                              Icons.report,
                              color: _apiResponse.data[index].status == 'A'
                                  ? Colors.yellow[600]
                                  : Colors.red[900],
                            ),
                      title: Text(
                        _apiResponse.data[index].title,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      subtitle: Text(
                          'Reportado el ${formatDateTime(_apiResponse.data[index].createdAt)}'),
                      onTap: () {
                        /* Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (_) => NoteModify(
                                noteID: _apiResponse.data[index].noteID)))
                        .then((data) {
                      _fetchReports();
                    }); */
                      },
                    ),
                  );
                },
                itemCount: _apiResponse.data.length,
              );
            })),
      ),
      onRefresh: _getData,
    );
  }

  Future<void> _getData() async {
    setState(() {
      _fetchReports();
    });
  }
}
