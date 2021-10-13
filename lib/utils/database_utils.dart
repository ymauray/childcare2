import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart';

class DatabaseUtils {
  static sqlite.Database? _database;

  static Future<String> get _databasePath async => join(await sqlite.getDatabasesPath(), 'childcare.db');

  static Future<void> deleteDatabase() async {
    if (_database != null) {
      _database!.close();
      _database = null;
    }
    sqlite.deleteDatabase(await _databasePath);
  }

  static Future<sqlite.Database> getDatabase() async {
    if (_database != null) return _database!;

    //deleteDatabase(_databasePath);
    _database = await sqlite.openDatabase(
      await _databasePath,
      version: 1,
      onCreate: (db, version) {
        _create(db);
        for (var i = 2; i <= version; i++) {
          _upgradeTo(i, db);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) {
        for (var i = oldVersion + 1; i <= newVersion; i++) {
          _upgradeTo(i, db);
        }
      },
      onDowngrade: (db, oldVersion, newVersion) {
        print("Downgrading from $oldVersion to $newVersion");
      },
    );

    return _database!;
  }

  static void _create(sqlite.Database db) async {
    await db.execute('''
      CREATE TABLE folder(
        id INTEGER PRIMARY KEY,
        childFirstName TEXT,
        childLastName TEXT,
        childDateOfBirth TEXT,
        preschool INTEGER,
        allergies TEXT,
        parentsFullName TEXT,
        address TEXT,
        countryCode TEXT,
        phoneNumber TEXT,
        misc TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE entry(
        id INTEGER PRIMARY KEY,
        folderId INTEGER,
        date TEXT,
        preschool INTEGER,
        hours INTEGER,
        minutes INTEGER,
        lunch INTEGER,
        diner INTEGER,
        night INTEGER
      )
    ''');
  }

  static void _upgradeTo(int version, sqlite.Database db) async {}
}
