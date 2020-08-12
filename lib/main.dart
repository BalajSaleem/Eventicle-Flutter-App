import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/Activity.dart';
import 'components/activity_card.dart';
import 'pages/view_location.dart';
import 'pages/home.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.green[300],
      accentColor:  Colors.grey[600],
      backgroundColor: Colors.grey[800],
      fontFamily: 'TenorSans',
    ),
    routes:{
      '/' : (context) => Home(),
      '/location': (context) => ViewMapLocation(),
    }
  )
  );
}






