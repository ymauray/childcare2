import 'package:childcare2/utils/i18n_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import "package:gettext/gettext.dart";
import 'package:gettext_parser/gettext_parser.dart' as gettext_parser;

extension ChildCareLocalizationsExt on String {
  String t(BuildContext context) => ChildCareLocalizations.of(context).t(this);
}

class ChildCareLocalizationsDelegate extends LocalizationsDelegate<ChildCareLocalizations> {
  @override
  bool isSupported(Locale locale) {
    var isSupported = ["fr", "en"].contains(locale.languageCode);
    return isSupported;
  }

  @override
  Future<ChildCareLocalizations> load(Locale locale) async {
    String poContent = await rootBundle.loadString("assets/i18n/${locale.languageCode}.po");
    var regions = await FlutterLibphonenumber().getAllSupportedRegions();
    var currentCountryCode = WidgetsBinding.instance?.window.locale.countryCode;
    if (regions.containsKey(currentCountryCode)) {
      I18nUtils.region = regions[currentCountryCode];
    } else {
      I18nUtils.region = null;
    }
    return ChildCareLocalizations(poContent);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<ChildCareLocalizations> old) {
    return true;
  }
}

class ChildCareLocalizations {
  final _gt = Gettext(onWarning: ((message) {
    final r = RegExp(r'^No translation was found for msgid "(.*)" in msgctxt "(.*)" and domain "(.*)"$');
    final matches = r.firstMatch(message);
    var msgid = matches!.group(1);
    print("msgid \"$msgid\"\nmsgstr \"\"\n \n");
  }));
  ChildCareLocalizations(String poContent) {
    _gt.addLocale(gettext_parser.po.parse(poContent));
  }

  static ChildCareLocalizations of(BuildContext context) {
    return Localizations.of<ChildCareLocalizations>(context, ChildCareLocalizations)!;
  }

  String t(String msgid) {
    return _gt.gettext(msgid);
  }
}
