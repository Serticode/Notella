import 'package:notella/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notella/models/note.dart';

class RecycleBinHelper {
  static RecycleBinHelper _delRecycleBinHelper; // Singleton RecycleBinHelper
  static Database delDatabase; // Singleton Database

  //!FOR NOTES.
  String deleteTable = 'note_table';
  String delId = 'id';
  String delTitle = 'title';
  String delDescription = 'description';
  String delPriority = 'priority';
  String delDate = 'date';

  RecycleBinHelper.createInstance(); // Named constructor to create instance of RecycleBinHelper

  factory RecycleBinHelper() {
    if (_delRecycleBinHelper == null) {
      _delRecycleBinHelper = RecycleBinHelper
          .createInstance(); // This is executed only once, singleton object
    }
    return _delRecycleBinHelper;
  }

  Future<Database> get deletedDatabase async {
    if (delDatabase == null) {
      delDatabase = await initializeDatabase();
    }
    return delDatabase;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'deletedNotes.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $deleteTable($delId INTEGER PRIMARY KEY AUTOINCREMENT, $delTitle TEXT, '
        '$delDescription TEXT, $delPriority INTEGER, $delDate TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getDeletedNoteMapList() async {
    Database db = await this.deletedDatabase;

    //var result = await db.rawQuery('SELECT * FROM $deleteTable order by $delPriority ASC');
    var result = await db.query(deleteTable, orderBy: '$delDate ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertDeletedNote(Note note) async {
    Database db = await this.deletedDatabase;

    var result = await db.insert(deleteTable, note.toMap());
    return result;
  }

  // Restore Operation: Restore a deleted note.
  Future<int> restoreDeletedNote(int id) async {
    var db = await this.deletedDatabase;
    var noteObject = await db.query(deleteTable, where: "$delId = $id");

    noteObject.forEach((element) async {
      Note note = Note.fromMapObject(element);
      await DatabaseHelper().insertNote(note);
    });

    int result =
        await db.rawDelete('DELETE FROM $deleteTable WHERE $delId = $id');
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteDeletedNote(int id) async {
    var db = await this.deletedDatabase;

    int result =
        await db.rawDelete('DELETE FROM $deleteTable WHERE $delId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.deletedDatabase;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $deleteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getDeletedNoteList() async {
    var noteMapList =
        await getDeletedNoteMapList();
    int count =
        noteMapList.length;

    List<Note> noteList = [];
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
