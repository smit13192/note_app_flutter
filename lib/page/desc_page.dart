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
      child: Scaffold(
        appBar: AppBar(
          title: Text(note.title),
        ),
          body: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Hero(
                tag: Key(note.desc),
                child: Text(
                  note.desc,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            )),
            const Divider(
              thickness: 1,
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.greenAccent,
                  ),
                  margin: const EdgeInsets.only(right: 10, top: 5),
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
                        color: Colors.white,
                      )),
                )),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.redAccent,
                    ),
                    margin: const EdgeInsets.only(left: 10, top: 5),
                    child: IconButton(
                        tooltip: "Delete Note",
                        onPressed: () {
                          _showSnackBar(
                              context, note, "Are you sure delete the note");
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      )),
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
