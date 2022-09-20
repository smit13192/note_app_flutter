import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/database/note_database.dart';
import 'package:note/note/note.dart';
import 'dart:async';

class SeeNotePage extends StatefulWidget {
  const SeeNotePage({Key? key}) : super(key: key);

  @override
  State<SeeNotePage> createState() => _SeeNotePageState();
}

class _SeeNotePageState extends State<SeeNotePage> {
  late List<Note> notes;

  bool isLoop = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope (
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: isLoop
              ? ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              "/UpgradeNote",
                              arguments: notes[index]);
                        },
                        title: Text(notes[index].title),
                        subtitle: Text(notes[index].desc),
                        trailing: InkWell(
                            onTap: () {
                              deleteNote(notes[index].id);
                              showSnackBar(context);
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

  Future loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    notes = await NoteDataBase().getNotes();
    setState(() {
      isLoop = true;
    });
  }

  void deleteNote(int? id) async {
    var success = await NoteDataBase().deleteNote(id!);
    loadData();
  }

  void showSnackBar(BuildContext context) {
    var alertDialog = const AlertDialog(
      icon: Icon(Icons.delete_rounded),
      title: Text('delete successfully'),
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}
