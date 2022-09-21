import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/database/note_database.dart';
import 'package:note/note/note.dart';

class SeeNotePage extends StatefulWidget {
  const SeeNotePage({Key? key}) : super(key: key);

  @override
  State<SeeNotePage> createState() => _SeeNotePageState();
}

class _SeeNotePageState extends State<SeeNotePage> {
  late List<Note> _notes;

  bool _isNull = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope (
      onWillPop: () async {
        _loadData();
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: _isNull
              ? ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              "/UpgradeNote",
                              arguments: _notes[index]);
                        },
                        title: Text(_notes[index].title),
                        subtitle: Text(_notes[index].desc),
                        trailing: InkWell(
                            onTap: () {
                              _deleteNote(_notes[index].id);
                              _showSnackBar(context,"Delete note");
                            },
                            child: const Icon(Icons.delete_rounded)),
                      ),
                    );
                  })
              : const Center(child: CircularProgressIndicator()),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, "/AddNote");
            }),
      ),
    );
  }

  _loadData() async {
    _notes = await NoteDataBase().getNotes();
    setState(() {
      _isNull = true;
    });
  }

  void _deleteNote(int? id) async {
    NoteDataBase noteDataBase = NoteDataBase();
    var success = await noteDataBase.deleteNote(id!);
    _loadData();
  }

  _showSnackBar(BuildContext context,String content) {
    var snackBar = SnackBar(content: Text(content));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
