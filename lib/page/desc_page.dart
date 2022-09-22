import 'package:flutter/material.dart';
import 'package:note/database/note_database.dart';
import 'package:note/note/note.dart';
import 'package:note/page/add_note_page.dart';

class SeeDescriptionPage extends StatelessWidget {
  final Note note;
  final NoteDataBase _dataBase = NoteDataBase();

  SeeDescriptionPage(this.note, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (Route<dynamic> route) => false);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
            body: Padding(
          padding:
              const EdgeInsets.only(left: 16.0, right: 16, top: 20, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                note.title,
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Text(
                  note.desc,
                  style: Theme.of(context).textTheme.headline2,
                ),
              )),
              const Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  Expanded(
                      child: Card(
                    elevation: 1,
                    color: const Color.fromARGB(255, 234, 234, 234),
                    child: IconButton(
                        tooltip: "Edit Note",
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoteAddPage(note, 3)));
                        },
                        icon: const Icon(
                          Icons.edit,
                        )),
                  )),
                  Expanded(
                    child: Card(
                      elevation: 1,
                      color: const Color.fromARGB(255, 234, 234, 234),
                      child: IconButton(
                          tooltip: "Delete Note",
                          onPressed: () {
                            _showSnackBar(
                                context, note, "Are you sure delete the note");
                          },
                          icon: const Icon(Icons.delete_rounded)),
                    ),
                  )
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  _deleteNote() async {
    final success = await _dataBase.deleteNote(note.id!);
  }

  void _showSnackBar(BuildContext context, Note note, String content) {
    var snackBar = SnackBar(
      content: Text(content),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          _deleteNote();
          Navigator.pushNamedAndRemoveUntil(
              context, "/", (Route<dynamic> route) => false);
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
