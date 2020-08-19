import 'package:exodus/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:exodus/models/Person.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  String baseUrl = 'http://139.179.202.8:8080/api/v1/';
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void handleLogin() async {
    String email = emailController.text;
    String password = passwordController.text;
    print('handling login');
    http.Response response = await http.get('$baseUrl/persons/$email/$password');
    Person user = Person.fromJson(json.decode(response.body));
    print(user.name);
    var route = new MaterialPageRoute(builder: (BuildContext context) => new Home(user: user));
    Navigator.of(context).pushReplacement(route);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0, 40.0, 0.0, 0.0),
                  child: Text('Welcome to Eventicle',
                      style: TextStyle(
                          fontSize: 60.0, fontWeight: FontWeight.bold)),
                )
              ),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        obscureText: true,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.only(top: 15.0, left: 20.0),
                        child: InkWell(
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Container(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () { handleLogin();},
                            child: Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  )),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'New to Eventicle?',
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}