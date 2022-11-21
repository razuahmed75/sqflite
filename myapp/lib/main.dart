// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myapp/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SQFLITE",
      initialRoute: HomePage.path,
      routes: {
        HomePage.path: (context) => HomePage(),
      },
    );
  }
}
