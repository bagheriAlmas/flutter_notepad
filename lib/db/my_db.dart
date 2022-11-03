import '../model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDB {
  MyDB._init();

  static final MyDB instance = MyDB._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDB('mydb.db');
  }

  Future<Database> _initDB(String databaseName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const columnType = 'TEXT NOT NULL';
    await db.execute('''
  CREATE TABLE $tableNotes (
  ${NotesFields.id} $idType,
  ${NotesFields.title} $columnType,
  ${NotesFields.content} $columnType,
  ${NotesFields.color} $columnType,
  ${NotesFields.date} $columnType
  )
  ''');
  }

  Future<Note> createNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> getNoteByID(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: NotesFields.values,
      where: '${NotesFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception("ID $id not Found");
    }
  }

  Future<List<Note>> getNotes() async {
    final db = await instance.database;
    final result = await db.query(tableNotes);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NotesFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return db.delete(
      tableNotes,
      where: '${NotesFields.id} = ? ',
      whereArgs: [id],
    );
  }

  Future close() async{
    final db = await instance.database;
    db.close();
  }
}
