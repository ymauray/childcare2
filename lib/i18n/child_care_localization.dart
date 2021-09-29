import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import "package:gettext/gettext.dart";
import 'package:gettext_parser/gettext_parser.dart' as gettext_parser;

mixin I18n {
  ChildCareLocalizations initI18n(BuildContext context) {
    return ChildCareLocalizations.of(context);
  }
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
