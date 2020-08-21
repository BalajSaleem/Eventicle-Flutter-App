import 'package:exodus/pages/view_qr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pages/view_location.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/sign_up.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.green[300],
      accentColor:  Colors.grey[600],
      backgroundColor: Colors.grey[800],
      fontFamily: 'TenorSans',
    ),
    initialRoute: '/login',
    routes:{
      '/home': (context) => Home(),
      '/location': (context) => ViewMapLocation(),
      '/login' : (context) => Login(),
      '/register' : (context) => SignUp(),
      '/qr': (context) => QrCodeViewer()
    }
  )
  );
}






