import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'dBContactList');
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    await database.execute('''
          CREATE TABLE contactListTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            image TEXT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            email TEXT NOT NULL
          )
          ''');

    await database.execute('''
          CREATE TABLE signupDataTable (
            logid INTEGER PRIMARY KEY AUTOINCREMENT,
            logemail TEXT NOT NULL,
            password TEXT NOT NULL
          )
          ''');
  }
}
