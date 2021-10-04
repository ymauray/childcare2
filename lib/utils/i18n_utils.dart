// ignore: implementation_imports
import 'package:flutter_libphonenumber/src/country_data.dart';

class I18nUtils {
  static CountryWithPhoneCode? region;

  static String? get currentCountryCode {
    return region?.countryCode;
  }

  static String? get phoneCode {
    return region?.phoneCode;
  }
}
