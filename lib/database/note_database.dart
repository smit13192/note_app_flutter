import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

import '../note/note.dart';

class NoteDataBase {
  // this is the singleton object to this class and private
  static final NoteDataBase instance = NoteDataBase._getInstance();

  // this is the singleton database object and private
  static Database? _database;

  // this is the column name to table
  String tableName = "note";
  String colId = "id";
  String colTitle = "title";
  String colDesc = "desc";

  // this is the private,named construct to the NoteDataBase class
  NoteDataBase._getInstance();

  // this is the factory construct to the return the this class singleton object
  factory NoteDataBase() {
    return instance;
  }

  // this is the return the database object to this class
  Future<Database> get database async {
    // if database object is not null when return the database object
    if (_database != null) {
      return _database!;
    }
    // else initialize object and return
    _database = await initializeDatabase();
    return _database!;
  }

  // initialize database function when database is the null
  Future<Database> initializeDatabase() async {
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
        "CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDesc TEXT)");
  }

  // close the Database method
  Future<void> closeDatabase() async {
    final db = await instance.database;
    db.close();
  }

  // insert records in the database table
  Future<Note> insertNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableName, note.toMap());
    return note.copy(id: id);
  }

  // return the all records in the database in the list
  Future<List<Note>> getNotes() async {
    final db = await instance.database;
    final result = await db.query(tableName);

    return result.map<Note>((note) => Note.fromMap(note)).toList();
  }

  // upgrade record in the database
  Future<int> upgradeNote(Note note) async {
    final db = await instance.database;
    final success = await db.update(tableName, note.toMap(),
        where: "$colId = ?", whereArgs: [note.id]);
    return success;
  }

  // delete record in the database
  Future<int> deleteNote(int? id) async {
    var db = await instance.database;
    var success = await db.delete(tableName, where: "$colId = ?", whereArgs: [id]);
    return success;
  }

  // get total number of the records
  Future<int?> getCount() async {
    var db = await instance.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT(*) FROM $tableName");
    int? result = Sqflite.firstIntValue(x);
    return result;
  }
}
