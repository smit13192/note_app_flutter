import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme() => ThemeData(
      scaffoldBackgroundColor: creamColor,
      textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
      inputDecorationTheme:
          const InputDecorationTheme(focusColor: Colors.blueAccent));

  static Color creamColor = const Color.fromARGB(255, 238, 238, 238);
}
