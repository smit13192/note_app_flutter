import 'package:flutter/material.dart';
import 'package:note/page/add_note_page.dart';
import 'package:note/route/generate_route.dart';
import 'package:note/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MyTheme.lightTheme(),
      darkTheme: MyTheme.darkTheme(),
      initialRoute: "/",
      onGenerateRoute: RouteGenerate.generateRoute,
    );
  }
}
