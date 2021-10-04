class Entry {
  DateTime date;
  int hours;
  int minutes;
  bool lunch;
  bool diner;
  bool night;

  Entry()
      : date = DateTime.now(),
        hours = 0,
        minutes = 0,
        lunch = false,
        diner = false,
        night = false;
}
