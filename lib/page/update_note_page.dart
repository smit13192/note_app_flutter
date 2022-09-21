import 'package:flutter/material.dart';
import 'package:note/database/note_database.dart';
import 'package:note/note/note.dart';

class UpdateNote extends StatefulWidget {
  Note note;

  UpdateNote({Key? key, required this.note}) : super(key: key);

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  double minHeight = 5;

  TextEditingController title = TextEditingController();

  TextEditingController desc = TextEditingController();

  @override
  void initState() {
    super.initState();
    title.text = widget.note.title;
    desc.text = widget.note.desc;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Update Note",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: minHeight * 3,
                ),
                TextFormField(
                  controller: title,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Enter Title"),
                ),
                SizedBox(
                  height: minHeight * 3,
                ),
                TextFormField(
                  controller: desc,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Description"),
                ),
                SizedBox(
                  height: minHeight * 3,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (title.text.trim().isNotEmpty &&
                          desc.text.trim().isNotEmpty) {
                        widget.note.title = title.text.trim();
                        widget.note.desc = desc.text.trim();
                        _upgradeNote(widget.note);
                        Navigator.pushReplacementNamed(context, "/SeeNote");
                      }
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: minHeight * 3),
                    )),
                    child: const Text("Update Note"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _upgradeNote(Note note) async {
    NoteDataBase noteDataBase = NoteDataBase();
    final int = await noteDataBase.upgradeNote(note);
  }
}