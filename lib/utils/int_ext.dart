extension StringExt on int {
  String toPaddedString(int minLength) {
    var str = toString();
    if (str.length >= minLength) return str;
    return "0" * (minLength - str.length) + str;
  }
}
