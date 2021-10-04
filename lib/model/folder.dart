import 'package:childcare2/utils/i18n_utils.dart';
import 'package:intl/intl.dart';

class Folder {
  int? id;
  String childFirstName;
  String childLastName;
  DateTime? childDateOfBirth;
  bool? preschool;
  String? allergies;
  String parentsFullName;
  String address;
  String? phoneNumber;
  String? misc;
  String countryCode;

  Folder()
      : childFirstName = "",
        childLastName = "",
        parentsFullName = "",
        address = "",
        countryCode = "+${I18nUtils.phoneCode!}";

  Folder.clone(Folder other)
      : childFirstName = other.childFirstName,
        childLastName = other.childLastName,
        childDateOfBirth = other.childDateOfBirth,
        preschool = other.preschool,
        allergies = other.allergies,
        parentsFullName = other.parentsFullName,
        address = other.address,
        phoneNumber = other.phoneNumber,
        misc = other.misc,
        countryCode = other.countryCode;

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
      'allergies': allergies,
      'parentsFullName': parentsFullName,
      'address': address,
      'phoneNumber': phoneNumber,
      'misc': misc,
      'countryCode': phoneNumber == null ? null : countryCode,
    };
  }

  Folder.fromDbMap(Map<String, Object?> row)
      : id = row['id'] as int,
        childFirstName = row['childFirstName'] as String,
        childLastName = row['childLastName'] as String? ?? '',
        childDateOfBirth = row['childDateOfBirth'] == null ? null : DateTime.parse(row['childDateOfBirth'] as String),
        preschool = row['preschool'] == null ? null : (row['preschool'] == 1),
        allergies = row['allergies'] as String?,
        parentsFullName = row['parentsFullName'] as String? ?? '',
        address = row['address'] as String? ?? '',
        phoneNumber = row['phoneNumber'] as String?,
        misc = row['misc'] as String?,
        countryCode = row['countryCode'] as String? ?? "+${I18nUtils.phoneCode!}";
}
