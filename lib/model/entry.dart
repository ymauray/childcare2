class Entry {
  DateTime date;
  int hours;
  int minutes;
  bool diner;
  bool night;

  Entry()
      : date = DateTime.now(),
        hours = 0,
        minutes = 0,
        diner = false,
        night = false;
}
