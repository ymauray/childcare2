import 'dart:developer';

import 'package:childcare2/utils/database_utils.dart';
import 'package:sqflite_common/sqlite_api.dart';

class Settings {
  double hourlyWeekRate = 0.0;
  double hourlyWeekendRate = 0.0;
  double lunchPreSchool = 0.0;
  double lunchKindergarten = 0.0;
  double dinerPreSchool = 0.0;
  double dinerKindergarten = 0.0;
  double overnight = 0.0;

  void save(Database db) async {
    await db.delete('settings');
    await db.insert('settings', {'key': 'hourlyWeekRate', 'value': hourlyWeekRate.toStringAsFixed(2)});
    await db.insert('settings', {'key': 'hourlyWeekendRate', 'value': hourlyWeekendRate.toStringAsFixed(2)});
    await db.insert('settings', {'key': 'lunchPreSchool', 'value': lunchPreSchool.toStringAsFixed(2)});
    await db.insert('settings', {'key': 'lunchKindergarten', 'value': lunchKindergarten.toStringAsFixed(2)});
    await db.insert('settings', {'key': 'dinerPreSchool', 'value': dinerPreSchool.toStringAsFixed(2)});
    await db.insert('settings', {'key': 'dinerKindergarten', 'value': dinerKindergarten.toStringAsFixed(2)});
    await db.insert('settings', {'key': 'overnight', 'value': overnight.toStringAsFixed(2)});
  }

  Future<Settings> load() {
    return DatabaseUtils.getDatabase().then((db) {
      return db.query('settings');
    }).then((rows) {
      for (var row in rows) {
        if (row['key'] == 'hourlyWeekRate') hourlyWeekRate = double.parse(row['value'] as String);
        if (row['key'] == 'hourlyWeekendRate') hourlyWeekendRate = double.parse(row['value'] as String);
        if (row['key'] == 'lunchPreSchool') lunchPreSchool = double.parse(row['value'] as String);
        if (row['key'] == 'lunchKindergarten') lunchKindergarten = double.parse(row['value'] as String);
        if (row['key'] == 'dinerPreSchool') dinerPreSchool = double.parse(row['value'] as String);
        if (row['key'] == 'dinerKindergarten') dinerKindergarten = double.parse(row['value'] as String);
        if (row['key'] == 'overnight') overnight = double.parse(row['value'] as String);
      }
      return this;
    });
  }
}

var settings = Settings();
