import 'package:flutter/material.dart';

import '../page/add_note_page.dart';
import '../page/see_note_page.dart';

class RouteGenerate {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const SeeNotePage());
      default:
        return MaterialPageRoute(builder: (context) => const SeeNotePage());
    }
  }
}
