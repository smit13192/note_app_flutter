import 'package:flutter/material.dart';
import 'package:note/note/note.dart';
import 'package:note/page/update_note_page.dart';

import '../page/add_note_page.dart';
import '../page/see_note_page.dart';

class RouteGenerate {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/AddNote":
        return MaterialPageRoute(builder: (context) => const NoteAddPage());

      case "/SeeNote":
        return MaterialPageRoute(builder: (context) => const SeeNotePage());

      case "/UpgradeNote":
        var args = settings.arguments;
        if (args is Note) {
          return MaterialPageRoute(
              builder: (context) => UpdateNote(note: args));
        } else {
          return MaterialPageRoute(builder: (context) => const NoteAddPage());
        }

      default:
        return MaterialPageRoute(builder: (context) => const NoteAddPage());
    }
  }
}
