import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

import '../note/note.dart';

class NoteDataBase {
  // this is the singleton object to this class and private
  static final NoteDataBase _instance = NoteDataBase._getInstance();

  // this is the singleton database object and private
  static Database? _database;

  // this is the column name to table
  final String _tableName = "note";
  final String _colId = "id";
  final String _colTitle = "title";
  final String _colDesc = "desc";

  // this is the private,named construct to the NoteDataBase class
  NoteDataBase._getInstance();

  // this is the factory construct to the return the this class singleton object
  factory NoteDataBase() {
    return _instance;
  }

  // this is the return the database object to this class
  Future<Database> get database async {
    // if database object is not null when return the database object
    if (_database != null) {
      return _database!;
    }
    // else initialize object and return
    _database = await _initializeDatabase();
    return _database!;
  }

  // initialize database function when database is the null
  Future<Database> _initializeDatabase() async {
    // give the directory
    Directory directory = await getApplicationDocumentsDirectory();

    // give the path of the directory and add the database name to the directory
    final path = "${directory.path}note.db";

    // create database object to the openDatabase function in the sqlite library
    Database database =
        await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  // create table in the database
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $_tableName($_colId INTEGER PRIMARY KEY AUTOINCREMENT,$_colTitle TEXT,$_colDesc TEXT)");
  }

  // close the Database method
  Future<void> _closeDatabase() async {
    final db = await _instance.database;
    db.close();
  }

  // insert records in the database table
  Future<Note> insertNote(Note note) async {
    final db = await _instance.database;
    final id = await db.insert(_tableName, note.toMap());
    return note.copy(id: id);
  }

  // return the all records in the database in the list
  Future<List<Note>> getNotes() async {
    final db = await _instance.database;
    final result = await db.query(_tableName);

    return result.map<Note>((note) => Note.fromMap(note)).toList();
  }

  // upgrade record in the database
  Future<int> upgradeNote(Note note) async {
    final db = await _instance.database;
    final success = await db.update(_tableName, note.toMap(),
        where: "$_colId = ?", whereArgs: [note.id]);
    return success;
  }

  // delete record in the database
  Future<int> deleteNote(int? id) async {
    var db = await _instance.database;
    var success =
        await db.delete(_tableName, where: "$_colId = ?", whereArgs: [id]);
    return success;
  }

  // get total number of the records
  Future<int?> getCount() async {
    var db = await _instance.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT(*) FROM $_tableName");
    int? result = Sqflite.firstIntValue(x);
    return result;
  }
}
