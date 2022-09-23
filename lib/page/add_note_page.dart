import "package:flutter/material.dart";
import 'package:note/database/note_database.dart';
import 'package:note/note/note.dart';
import 'package:note/page/desc_page.dart';

class NoteAddPage extends StatefulWidget {
  Note note;
  int isInserted;

  NoteAddPage(this.note, this.isInserted, {super.key});

  @override
  State<NoteAddPage> createState() => _NoteAddPageState();
}

// if isInserted is true when insert new note then update note
class _NoteAddPageState extends State<NoteAddPage> {
  final NoteDataBase _database = NoteDataBase();

  final _title = TextEditingController();
  final _desc = TextEditingController();
  final double _minHeight = 5;

  // this is the DropDownButton
  // this two are the choose option high means 1 and low means 2
  // final List<String> _priority = ["High", "Low"];
  late String _choosePriority;

  // init state ma set _choosePriority,TextFormField for title and TextFormField for desc
  @override
  void initState() {
    super.initState();
    _choosePriority = widget.note.priority == 1 ? "High" : "Low";
    _title.text = widget.note.title;
    _desc.text = widget.note.desc;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isInserted == 3) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SeeDescriptionPage(widget.note)));
        } else {
          Navigator.pop(context);
        }

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
                  // if isInserted is true when add note else Update Note
                  widget.isInserted == 1 ? "Add Note" : "Update Note",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: _minHeight * 2,
                ),
                SizedBox(
                  height: _minHeight * 3,
                ),
                TextFormField(
                  controller: _title,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Title",
                      hintText: "Enter Title"),
                ),
                SizedBox(
                  height: _minHeight * 3,
                ),
                TextFormField(
                  controller: _desc,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Description",
                      hintText: "Enter Description"),
                ),
                SizedBox(
                  height: _minHeight * 3,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: _minHeight * 3),
                  child: Row(
                    children: [
                      Expanded(child: _radioListTile("High", Colors.redAccent)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: _radioListTile("Low", Colors.greenAccent)),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_title.text.trim().isNotEmpty &&
                          _desc.text.trim().isNotEmpty) {
                        _insertNote();
                        _navigatePage();
                      } else {
                        // see snackBar when input text is invalid
                        _showSnackBar(
                            context, "Enter valid title and description");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: _minHeight * 3),
                        )),
                    // if isInserted is true when add note else Update Note
                    child: widget.isInserted == 1
                        ? const Text("Add Note")
                        : const Text("Update Note"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _insertNote() async {
    if (widget.isInserted == 1) {
      // add new note
      bool isHigh = _choosePriority == "High";
      // make new note
      Note note = Note(_title.text.trim(), _desc.text.trim(), isHigh ? 1 : 2);
      // inserted new note
      note = (await _database.insertNote(note));
    } else {
      // condition check if _choosePriority high when true else false
      bool isHigh = _choosePriority == "High";
      // set note title and desc
      widget.note.title = _title.text.trim();
      widget.note.desc = _desc.text.trim();
      // isHigh is true when 1 else 2
      widget.note.priority = isHigh ? 1 : 2;
      // update note for this is note
      final success = await _database.upgradeNote(widget.note);
    }
  }

  _navigatePage() {
    if (widget.isInserted == 1 || widget.isInserted == 2) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/", (Route<dynamic> route) => false);
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SeeDescriptionPage(widget.note)));
    }
  }

  // see snackBar when input text is invalid
  void _showSnackBar(BuildContext context, String content) {
    var snackBar = SnackBar(content: Text(content));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // this is make the radio button to the value and color
  RadioListTile _radioListTile(String value, Color selectedColor) {
    return RadioListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        tileColor:
            _choosePriority == value ? selectedColor : Colors.transparent,
        activeColor: Colors.white,
        value: value,
        title: Text(
          value,
          style: TextStyle(
            color: _choosePriority == value ? Colors.white : Colors.black,
          ),
        ),
        groupValue: _choosePriority,
        onChanged: (changedValue) {
          setState(() {
            _choosePriority = changedValue!;
          });
        });
  }
}
