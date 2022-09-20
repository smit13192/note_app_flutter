import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme() => ThemeData(
      textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)));

  static ThemeData darkTheme() => ThemeData();
}
