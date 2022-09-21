import "package:flutter/material.dart";
import 'package:note/database/note_database.dart';
import 'package:note/note/note.dart';

class NoteAddPage extends StatefulWidget {
  const NoteAddPage({super.key});

  @override
  State<NoteAddPage> createState() => _NoteAddPageState();
}

class _NoteAddPageState extends State<NoteAddPage> {
  final NoteDataBase _database = NoteDataBase();

  final _title = TextEditingController();
  final _desc = TextEditingController();
  final double _minHeight = 5;

  final List<String> _priority = ["High", "Low"];
  String _choosePriority = "High";

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
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Add Note",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: _minHeight * 6,
                ),
                DropdownButton<String>(
                  itemHeight: 60,
                  elevation: 20,
                  items: _priority
                      .map((dropDownMenuItem) => DropdownMenuItem<String>(
                            value: dropDownMenuItem,
                            child: Text(dropDownMenuItem),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _choosePriority = value!;
                    });
                  },
                  value: _choosePriority,
                ),
                SizedBox(
                  height: _minHeight * 3,
                ),
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Enter Title"),
                ),
                SizedBox(
                  height: _minHeight * 3,
                ),
                TextFormField(
                  controller: _desc,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Description"),
                ),
                SizedBox(
                  height: _minHeight * 3,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_title.text.isNotEmpty && _desc.text.isNotEmpty) {
                        _insertNote();
                      }
                      Navigator.pushReplacementNamed(context, "/");
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: _minHeight * 3),
                    )),
                    child: const Text("Add Note"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _insertNote() async {
    bool isHigh = _choosePriority == "High";
    Note note = Note(_title.text, _desc.text, isHigh ? 1 : 2);
    note = (await _database.insertNote(note));
  }
}
