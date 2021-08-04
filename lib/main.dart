import 'package:flutter/material.dart';
import 'package:ujian_online/views/dashboard.dart';
import 'package:ujian_online/views/detail.dart';
import 'package:ujian_online/views/history.dart';
import 'package:ujian_online/views/login.dart';
import 'package:ujian_online/views/nilai.dart';
import 'package:ujian_online/views/soal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => Login(),
        "/dashboard": (context) => Dashboard(),
        "/detail": (context) => Detail(),
        "/history": (context) => History(),
        "/soal": (context) => Soal(),
        "/nilai": (context) => Nilai(),
      },
    );
  }
}