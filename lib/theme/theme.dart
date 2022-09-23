import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme() => ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          // this is to the add Note page title
          headline1: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.black,
          ),

          // this is for tile title
          headline2: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),

          // this is for describe page title
          headlineLarge: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),

          // this is for describe page description
          headline3: TextStyle(fontSize: 20, color: Colors.black),
        ),
      );

  static ThemeData darkTheme() => ThemeData();
}
