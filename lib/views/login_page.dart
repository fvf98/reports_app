import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reports_app/models/auth.dart';
import 'package:reports_app/services/auth_service.dart';
import 'package:reports_app/views/home_page.dart';

import 'color_loader.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService get authService => GetIt.I<AuthService>();

  bool _isLoading = false;
  Auth auth;

  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 75.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextField(
        controller: _userController,
        style: TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
            hintText: 'Usuario',
            hintStyle: TextStyle(color: Colors.white),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(color: Colors.white, width: 1.0)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(color: Colors.white, width: 1.0))));

    final password = TextField(
        controller: _passwordController,
        obscureText: true,
        style: TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
            hintText: 'Contraseña',
            hintStyle: TextStyle(color: Colors.white),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(color: Colors.white, width: 1.0)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(color: Colors.white, width: 1.0))));

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });

          final auth = Auth(
              userName: _userController.text,
              password: _passwordController.text);
          final result = await authService.login(auth);

          setState(() {
            _isLoading = false;
          });

          final title = result.error ? 'Error' : 'Done';
          final text = result.message;

          if (result.error) {
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
                    )).then((data) {});
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()),
                (Route<dynamic> route) => false);
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue[800],
        child: Text('Iniciar sesion',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );

    final title = Center(
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Text('FIM Cerca de ti',
                style: TextStyle(color: Colors.white, fontSize: 30))));

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Center(
        child: _isLoading
            ? Center(
                child: ColorLoader(
                radius: 25.0,
                dotRadius: 10.0,
              ))
            : ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  title,
                  logo,
                  SizedBox(height: 25.0),
                  email,
                  SizedBox(height: 8.0),
                  password,
                  SizedBox(height: 24.0),
                  loginButton
                ],
              ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
    );
  }
}
