import 'package:flutter/material.dart';

class ConfirmAlert extends StatefulWidget {
  final String text;

  ConfirmAlert({this.text});
  @override
  _ConfirmAlertState createState() => _ConfirmAlertState();
}

class _ConfirmAlertState extends State<ConfirmAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('¡Cuidado!'),
      content: Text(widget.text),
      actions: <Widget>[
        FlatButton(
          child: Text('Si'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
