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
      version: 7,
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
        parentsFullName TEXT,
        address TEXT
      )
      ''');
  }

  static void _upgradeTo(int version, sqlite.Database db) async {
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

    if (version == 4) {
      await db.execute('''
      ALTER TABLE folder ADD allergies TEXT
      ''');
    }

    if (version == 5) {
      await db.execute('''
      ALTER TABLE folder ADD phoneNumber TEXT
      ''');
    }

    if (version == 6) {
      await db.execute('''
      ALTER TABLE folder ADD misc TEXT
      ''');
    }

    if (version == 7) {
      await db.execute('''
      ALTER TABLE folder ADD countryCode TEXT
      ''');
    }
  }
}
