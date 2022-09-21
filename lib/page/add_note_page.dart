import "package:flutter/material.dart";
import 'package:note/database/note_database.dart';
import 'package:note/note/note.dart';

class NoteAddPage extends StatefulWidget {
  const NoteAddPage({super.key});

  @override
  State<NoteAddPage> createState() => _NoteAddPageState();
}

class _NoteAddPageState extends State<NoteAddPage> {
  double minHeight = 5;

  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Add Note",
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
                      _insertNote();
                      Navigator.pushReplacementNamed(context, "/SeeNote");
                    } else {
                      _showSnackBar(context,"Enter valid title and description");
                    }
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: minHeight * 3),
                  )),
                  child: const Text("Add Note"))
            ],
          ),
        ),
      ),
    );
  }

  _insertNote() async {
    Note note = Note(title: title.text.trim(), desc: desc.text.trim());
    note = (await NoteDataBase().insertNote(note));
  }

  _showSnackBar(BuildContext context,String content) {
    var snackBar = SnackBar(content: Text(content));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
