import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/database/note_database.dart';
import 'package:note/note/note.dart';
import 'package:note/page/add_note_page.dart';
import 'package:note/page/desc_page.dart';

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
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Notes"),
        ),
        body: isNull
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : notes.isNotEmpty
                ? ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SeeDescriptionPage(notes[index])));
                        },
                        // card long pressed when update note
                        onLongPress: () {
                          // update note false
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NoteAddPage(notes[index], 2)));
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
                        title: Hero(
                            tag: Key(notes[index].title),
                            child: Text(notes[index].title)),
                        subtitle: Hero(
                            tag: Key(notes[index].desc),
                            child: _giveDesc(notes[index])),

                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_rounded,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            _showSnackBar(context, notes[index],
                                "Are you sure delete note");
                          },
                        ),
                      );
                    })
                : const Center(
                    child: Text("Add Note"),
                  ),
        // add the new note in to the database
        floatingActionButton: FloatingActionButton(
          tooltip: "Add New Note",
          onPressed: () {
            // add new note
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteAddPage(Note("", "", 1), 1)));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // get records to the notes list
  void _getRecords() async {
    notes = await _dataBase.getNotes();
    setState(() {
      isNull = false;
    });
  }

  // show snackBar to the delete note
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

  // delete note
  void _deleteNote(Note note) async {
    final success = await _dataBase.deleteNote(note.id!);
    _getRecords();
  }

  // this is for listview builder subtitle mate che
  Text _giveDesc(Note note) {
    return note.desc.length > 35
        ? note.desc.contains("\n")
            ? Text("${note.desc.substring(0, note.desc.indexOf("\n"))}.....")
            : Text("${note.desc.substring(0, 30)}.....")
        : note.desc.contains("\n")
            ? Text("${note.desc.substring(0, note.desc.indexOf("\n"))}.....")
            : Text(note.desc);
  }
}
