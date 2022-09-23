import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

import '../note/note.dart';

class NoteDataBase {
  // this is the singleton object to this class and private
  static NoteDataBase? _noteDataBase;

  // this is the singleton database object and private
  static Database? _database;

  // this is the column name to table
  String tableName = "note";
  String colId = "id";
  String colTitle = "title";
  String colDesc = "desc";
  String priority = "priority";

  // this is the private,named construct to the NoteDataBase class
  NoteDataBase._getInstance();

  // this is the factory construct to the return the this class singleton object
  factory NoteDataBase() {
    if (_noteDataBase != null) {
      return _noteDataBase!;
    }
    _noteDataBase = NoteDataBase._getInstance();
    return _noteDataBase!;
  }

  // this is the return the database object to this class
  Future<Database> get database async {
    // if database object is not null when return the database object
    if (_database != null) {
      return _database!;
    }
    // else initialize object and return
    _database = await _initDB();
    return _database!;
  }

  // initialize database function when database is the null
  Future<Database> _initDB() async {
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
  _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDesc TEXT,$priority INTEGER)");
  }

  // insert records in the database table
  Future<Note> insertNote(Note note) async {
    final db = await database;
    final success = await db.insert(tableName, note.toMap());
    note = note.copy(id: success);
    return note;
  }

  // return the all records in the database in the list
  Future<List<Note>> getNotes() async {
    final db = await database;
    List<Map<String, Object?>> result =
        await db.query(tableName, orderBy: "$priority ASC");

    final notes = result.map<Note>((note) => Note.fromMap(note)).toList();
    return notes;
  }

  // upgrade record in the database
  Future<int> upgradeNote(Note note) async {
    final db = await database;
    final success = await db.update(tableName, note.toMap(),
        where: "$colId = ?", whereArgs: [note.id]);
    return success;
  }

  // delete record in the database
  Future<int> deleteNote(int id) async {
    final db = await database;
    final success =
        await db.delete(tableName, where: "$colId = ?", whereArgs: [id]);
    return success;
  }

  // get total number of the records
  Future<int?> getCount() async {
    final db = await database;
    List<Map<String, Object?>> x =
        await db.rawQuery("SELECT COUNT(*) FROM $tableName");
    int? result = Sqflite.firstIntValue(x);
    return result;
  }
}
