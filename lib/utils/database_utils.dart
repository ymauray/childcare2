import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseUtils {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    var databasePath = join(await getDatabasesPath(), 'childcare.db');
    //deleteDatabase(databasePath);
    _database = await openDatabase(
      databasePath,
      version: 3,
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

  static void _create(Database db) async {
    await db.execute('''
      CREATE TABLE folder(
        id INTEGER PRIMARY KEY,
        childFirstName TEXT,
        childLastName TEXT,
        parentsFullName TEXT,
        address TEXT
      )
      ''');
  }

  static void _upgradeTo(int version, Database db) async {
    if (version == 2) {
      await db.execute('''
      ALTER TABLE folder ADD childDateOfBirth TEXT
      ''');
    }

    if (version == 3) {
      await db.execute('''
      ALTER TABLE folder ADD preschool INTEGER
      ''');
    }
  }
}
