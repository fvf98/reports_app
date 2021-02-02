import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:reports_app/models/api_response.dart';
import 'package:reports_app/models/issue_type.dart';
import 'package:reports_app/models/report.dart';
import 'package:reports_app/models/report_assign.dart';
import 'package:reports_app/models/report_insert.dart';
import 'package:reports_app/services/issue_type_service.dart';
import 'package:reports_app/services/report_service.dart';
import 'package:reports_app/views/confirm_alert.dart';

import 'color_loader.dart';

class ReportModify extends StatefulWidget {
  final String id;
  final bool isJanitor;
  ReportModify({this.id, this.isJanitor});

  @override
  _ReportModifyState createState() => _ReportModifyState();
}

class _ReportModifyState extends State<ReportModify> {
  bool get isEditing => widget.id != null;
  bool get isJanitor => widget.isJanitor != null && widget.isJanitor != false;

  FlutterSecureStorage get storage => GetIt.I<FlutterSecureStorage>();
  ReportService get reportService => GetIt.I<ReportService>();
  IssueTypeService get issueTypeService => GetIt.I<IssueTypeService>();

  String message;
  Report report;
  APIResponse<List<IssueType>> _issues;
  APIResponse<Report> _report;
  num janitorId;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _issueTypeController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  num _issueTypeId;

  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    _fetchIssues();

    if (isEditing) _fetchReport();
    if (isJanitor) _fetchJanitorId();

    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  _fetchJanitorId() async {
    String id = await storage.read(key: 'id');
    setState(() {
      janitorId = num.parse(id);
    });
  }

  _fetchIssues() async {
    _issues = await issueTypeService.getIssueTypesList();
  }

  _fetchReport() async {
    _report = await reportService.getReport(widget.id);
    report = _report.data;
    _titleController.text = report.title;
    _locationController.text = report.location;
    _issueTypeId = report.issueType.id;
    _issueTypeController.text = report.issueType.title;
    _descriptionController.text = report.description;
  }

  getButtonText() {
    if (_report.data.asigned == null)
      return 'Aceptar reporte';
    else if (_report.data.asigned != null) return 'Terminar reporte';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              !isJanitor
                  ? isEditing
                      ? 'Modificar reporte'
                      : 'Nuevo reporte'
                  : 'Detalles de reporte',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue[800]),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(
                child: Center(
                    child: ColorLoader(
                radius: 25.0,
                dotRadius: 10.0,
              )))
            : Column(
                children: <Widget>[
                  TextField(
                    readOnly: isJanitor,
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Titulo de reporte'),
                  ),
                  Container(height: 8),
                  TextField(
                    readOnly: isJanitor,
                    controller: _locationController,
                    decoration:
                        InputDecoration(hintText: 'Ubicacion del problema'),
                  ),
                  Container(height: 8),
                  TextField(
                    controller: _issueTypeController,
                    readOnly: true,
                    showCursor: true,
                    decoration: InputDecoration(
                      hintText: 'Tipo de problema',
                      suffixIcon: PopupMenuButton<IssueType>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (IssueType value) {
                          _issueTypeController.text = value.title;
                          _issueTypeId = value.id;
                        },
                        itemBuilder: (BuildContext context) {
                          return _issues.data
                              .map<PopupMenuItem<IssueType>>((IssueType value) {
                            return new PopupMenuItem(
                                child: new Text(value.title), value: value);
                          }).toList();
                        },
                      ),
                    ),
                  ),
                  Container(height: 8),
                  TextField(
                    readOnly: isJanitor,
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Descripcion del problema',
                    ),
                  ),
                  Container(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: RaisedButton(
                      child: Text(isJanitor ? 'Continuar' : 'Guardar',
                          style: TextStyle(color: Colors.white)),
                      color: Colors.blue[800],
                      onPressed: () async {
                        if (isJanitor) {
                          setState(() {
                            _isLoading = true;
                          });

                          var assign;
                          var result;
                          var title;
                          var text;
                          var confirm;
                          if (_report.data.asigned == null) {
                            confirm = await showDialog(
                                context: context,
                                builder: (_) => ConfirmAlert(
                                    text:
                                        '¿Estas seguro de querer Aceptar este reporte?'));
                            if (confirm) {
                              assign = ReportAssign(asigned: janitorId);
                              result = await reportService.assignReport(
                                  widget.id, assign);

                              title = result.error ? 'Error' : 'Listo';
                              text = result.error
                                  ? (result.message ?? 'Ocurrio un error')
                                  : 'Reporte aceptado correctamente';
                            }
                          } else {
                            confirm = await showDialog(
                                context: context,
                                builder: (_) => ConfirmAlert(
                                    text:
                                        '¿Estas seguro de querer Concluir este reporte?'));
                            if (confirm) {
                              assign = ReportAssign(asigned: janitorId);
                              result = await reportService
                                  .finishReport(_report.data.id.toString());

                              title = result.error ? 'Error' : 'Listo';
                              text = result.error
                                  ? (result.message ?? 'Ocurrio un error')
                                  : 'Reporte terminado correctamente';
                            }
                          }
                          setState(() {
                            _isLoading = false;
                          });
                          if (confirm) {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(title),
                                      content: Text(text),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    )).then((data) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        } else {
                          if (isEditing) {
                            setState(() {
                              _isLoading = true;
                            });

                            final report = ReportInsert(
                                title: _titleController.text,
                                location: _locationController.text,
                                images: [],
                                issueType: _issueTypeId,
                                description: _descriptionController.text);
                            final result = await reportService.updateReport(
                                widget.id, report);

                            setState(() {
                              _isLoading = false;
                            });

                            final title = result.error ? 'Error' : 'Listo';
                            final text = result.error
                                ? (result.message ?? 'Ocurrio un error')
                                : 'Cambios guardados con exito';

                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(title),
                                      content: Text(text),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    )).then((data) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          } else {
                            setState(() {
                              _isLoading = true;
                            });

                            final report = ReportInsert(
                                title: _titleController.text,
                                location: _locationController.text,
                                images: [],
                                issueType: _issueTypeId,
                                description: _descriptionController.text);
                            final result =
                                await reportService.createReport(report);

                            setState(() {
                              _isLoading = false;
                            });

                            final title = result.error ? 'Error' : 'Listo';
                            final text = result.error
                                ? (result.message ?? 'Ocurrio un error')
                                : 'Reporte creado con exito';

                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(title),
                                      content: Text(text),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    )).then((data) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
