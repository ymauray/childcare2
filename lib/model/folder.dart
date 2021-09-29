import 'package:intl/intl.dart';

class Folder {
  int? id;
  String childFirstName;
  String childLastName;
  DateTime? childDateOfBirth;
  bool? preschool;
  String parentsFullName;
  String address;

  Folder()
      : childFirstName = "",
        childLastName = "",
        parentsFullName = "",
        address = "";

  Folder.clone(Folder other)
      : childFirstName = other.childFirstName,
        childLastName = other.childLastName,
        childDateOfBirth = other.childDateOfBirth,
        preschool = other.preschool,
        parentsFullName = other.parentsFullName,
        address = other.address;

  Folder mergeThisInto(Folder other) {
    Folder merged = Folder.clone(this);
    merged.id = other.id;
    return merged;
  }

  Map<String, Object?> toDbMap() {
    return {
      'childFirstName': childFirstName,
      'childLastName': childLastName,
      'childDateOfBirth': childDateOfBirth == null ? null : DateFormat('yyyy-MM-dd').format(childDateOfBirth!),
      'preschool': preschool == null ? null : (preschool! ? 1 : 0),
      'parentsFullName': parentsFullName,
      'address': address,
    };
  }

  Folder.fromDbMap(Map<String, Object?> row)
      : id = row['id'] as int,
        childFirstName = row['childFirstName'] as String,
        childLastName = row['childLastName'] as String? ?? '',
        childDateOfBirth = row['childDateOfBirth'] == null ? null : DateTime.parse(row['childDateOfBirth'] as String),
        preschool = row['preschool'] == null ? null : (row['preschool'] == 1),
        parentsFullName = row['parentsFullName'] as String? ?? '',
        address = row['address'] as String? ?? '';
}
