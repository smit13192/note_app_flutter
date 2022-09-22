import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme() => ThemeData(
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
          headline2: TextStyle(fontSize: 20, color: Colors.black)));

  static ThemeData darkTheme() => ThemeData();
}
