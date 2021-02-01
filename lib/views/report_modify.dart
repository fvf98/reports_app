import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reports_app/models/api_response.dart';
import 'package:reports_app/models/issue_type.dart';
import 'package:reports_app/models/report.dart';
import 'package:reports_app/models/report_insert.dart';
import 'package:reports_app/services/issue_type_service.dart';
import 'package:reports_app/services/report_service.dart';

class ReportModify extends StatefulWidget {
  final String id;
  ReportModify({this.id});

  @override
  _ReportModifyState createState() => _ReportModifyState();
}

class _ReportModifyState extends State<ReportModify> {
  bool get isEditing => widget.id != null;

  ReportService get reportService => GetIt.I<ReportService>();
  IssueTypeService get issueTypeService => GetIt.I<IssueTypeService>();

  String message;
  Report report;
  APIResponse<List<IssueType>> _issues;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _issueTypeController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  num _issueTypeId;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });

    if (isEditing) {
      reportService.getReport(widget.id).then((response) {
        if (response.error) {
          message = response.message ?? 'An error occurred';
        }
        report = response.data;
        _titleController.text = report.title;
        _locationController.text = report.location;
        _descriptionController.text = report.description;
        _descriptionController.text = report.description;
      });
    }

    _fetchIssues();

    setState(() {
      _isLoading = false;
    });
  }

  _fetchIssues() async {
    _issues = await issueTypeService.getIssueTypesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(isEditing ? 'Modificar reporte' : 'Nuevo reporte')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Titulo de reporte'),
                  ),
                  Container(height: 8),
                  TextField(
                    controller: _locationController,
                    decoration:
                        InputDecoration(hintText: 'Ubicacion del reporte'),
                  ),
                  Container(height: 8),
                  TextField(
                    controller: _issueTypeController,
                    readOnly: true,
                    showCursor: true,
                    decoration: InputDecoration(
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
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Descripcion del reporte',
                    ),
                  ),
                  Container(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: RaisedButton(
                      child:
                          Text('Submit', style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        /* 
                        if (isEditing) {
                          setState(() {
                            _isLoading = true;
                          });
                          final report = ReportInsert(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text);
                          final result = await reportService.updateReport(
                              widget.id, report);

                          setState(() {
                            _isLoading = false;
                          });

                          final title = result.error ? 'Error' : 'Done';
                          final text = result.error
                              ? (result.message ?? 'An error occurred')
                              : 'Your reportwas updated';

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
                          */
                        setState(() {
                          _isLoading = true;
                        });
                        final report = ReportInsert(
                            title: _titleController.text,
                            location: _locationController.text,
                            images: [],
                            issueType: _issueTypeId,
                            description: _descriptionController.text);
                        final result = await reportService.createReport(report);

                        setState(() {
                          _isLoading = false;
                        });

                        final title = result.error ? 'Error' : 'Done';
                        final text = result.error
                            ? (result.message ?? 'An error occurred')
                            : 'Your reportwas created';

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
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
