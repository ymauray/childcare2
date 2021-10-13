import 'dart:collection';

import 'package:childcare2/model/entry.dart';
import 'package:childcare2/utils/database_utils.dart';
import 'package:flutter/material.dart';

class EntryModel extends ChangeNotifier {
  /// Internal, private state of the model
  final List<Entry> _entries = [];

  /// An unmodifiable view of the model
  UnmodifiableListView<Entry> get items => UnmodifiableListView<Entry>(_entries);

  int get count => _entries.length;

  /// The pending billing total
  double get pendingBillingTotal => _entries.fold(0, (total, entry) {
        /// Week : 7.0
        /// Week-end : 8.0
        /// Lunch, diner : preschool 5.0, kindergarten 7.0
        /// Night : 20.0
        var weekDay = (entry.date.weekday != DateTime.sunday && entry.date.weekday != DateTime.saturday);
        return total +
            (weekDay ? 7.0 : 8.0) * (entry.hours + entry.minutes / 60.0) +
            (entry.lunch ? (entry.preschool ? 5.0 : 7.0) : 0.0) +
            (entry.diner ? (entry.preschool ? 5.0 : 7.0) : 0.0) +
            (entry.night ? 20 : 0.0);
      });

  /// Add an Entry to the model
  void add(Entry entry) {
    DatabaseUtils.getDatabase().then((db) => db.insert('entry', entry.toDbMap())).then((id) {
      entry.id = id;
      _entries.add(entry);
      _entries.sort((a, b) => b.date.microsecondsSinceEpoch - a.date.microsecondsSinceEpoch);
      notifyListeners();
    });
  }

  void loadForFolder(int id) {
    DatabaseUtils.getDatabase().then((db) {
      db.query('entry', where: 'folderId = ?', whereArgs: [id], orderBy: 'date desc').then((rows) {
        _entries.clear();
        _entries.addAll(rows.map((row) => Entry.fromDbMap(row)));
        notifyListeners();
      });
    });
  }

  void remove(Entry item) {
    DatabaseUtils.getDatabase().then((db) {
      db.delete('entry', where: 'id = ?', whereArgs: [item.id]).then((_) {
        _entries.removeWhere((element) => element.id == item.id);
        _entries.sort((a, b) => b.date.microsecondsSinceEpoch - a.date.microsecondsSinceEpoch);
        notifyListeners();
      });
    });
  }

  void update(Entry item) {
    DatabaseUtils.getDatabase().then((db) {
      db.update('entry', item.toDbMap(), where: 'id = ?', whereArgs: [item.id]).then((_) {
        _entries.removeWhere((element) => element.id == item.id);
        _entries.add(item);
        _entries.sort((a, b) => b.date.microsecondsSinceEpoch - a.date.microsecondsSinceEpoch);
        notifyListeners();
      });
    });
  }
}
