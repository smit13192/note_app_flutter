import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/database/note_database.dart';
import 'package:note/note/note.dart';
import 'package:note/page/add_note_page.dart';

class SeeNotePage extends StatefulWidget {
  const SeeNotePage({Key? key}) : super(key: key);

  @override
  State<SeeNotePage> createState() => _SeeNotePageState();
}

class _SeeNotePageState extends State<SeeNotePage> {
  bool isNull = true;
  late List<Note> notes;
  final NoteDataBase _dataBase = NoteDataBase();

  @override
  void initState() {
    super.initState();
    _getRecords();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _getRecords();
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Notes"),
          ),
          body: isNull
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: ListTile(
                            // card long pressed when update note
                            onLongPress: () {
                              // update note false
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NoteAddPage(notes[index], false)));
                            },
                            leading: CircleAvatar(
                              backgroundColor: notes[index].priority == 1
                                  ? Colors.redAccent
                                  : Colors.greenAccent,
                              child: Icon(
                                notes[index].priority == 1
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(notes[index].title),
                            subtitle: Text(notes[index].desc),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_rounded),
                              onPressed: () {
                                _showSnackBar(context, notes[index],
                                    "Are you sure delete note");
                              },
                            ),
                          ),
                        );
                      }),
                ),
          floatingActionButton: FloatingActionButton(
            tooltip: "Add New Note",
            onPressed: () {
              // add new note
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NoteAddPage(Note("", "", 1), true)));
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _getRecords() async {
    notes = await _dataBase.getNotes();
    setState(() {
      isNull = false;
    });
  }

  void _deleteNote(Note note) async {
    final success = await _dataBase.deleteNote(note.id!);
    _getRecords();
  }

  void _showSnackBar(BuildContext context, Note note, String content) {
    var snackBar = SnackBar(
      content: Text(content),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          _deleteNote(note);
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
