import 'package:intl/intl.dart';

class Entry {
  int? id;
  int folderId;
  DateTime date;
  bool preschool;
  int hours;
  int minutes;
  bool lunch;
  bool diner;
  bool night;

  Entry({required this.folderId, required this.preschool})
      : assert(folderId > 0),
        date = DateTime.now(),
        hours = 0,
        minutes = 0,
        lunch = false,
        diner = false,
        night = false;

  Map<String, Object?> toDbMap() {
    return {
      'folderId': folderId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'preschool': preschool ? 1 : 0,
      'hours': hours,
      'minutes': minutes,
      'lunch': lunch ? 1 : 0,
      'diner': diner ? 1 : 0,
      'night': night ? 1 : 0,
    };
  }

  Entry.fromDbMap(Map<String, Object?> row)
      : id = row['id'] as int,
        folderId = row['folderId'] as int,
        date = DateTime.parse(row['date'] as String),
        preschool = row['preschool'] as int == 1,
        hours = row['hours'] as int,
        minutes = row['minutes'] as int,
        lunch = row['lunch'] as int == 1,
        diner = row['diner'] as int == 1,
        night = row['night'] as int == 1;

  Entry.clone(Entry other)
      : folderId = other.folderId,
        date = other.date,
        preschool = other.preschool,
        hours = other.hours,
        minutes = other.minutes,
        lunch = other.lunch,
        diner = other.diner,
        night = other.night;
}
