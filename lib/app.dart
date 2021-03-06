import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/model/entry_model.dart';
import 'package:childcare2/pages/backup_and_restore.dart';
import 'package:childcare2/pages/entries_page.dart';
import 'package:childcare2/pages/home_page.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class ChildCareApp extends StatelessWidget {
  const ChildCareApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //theme: yaru.lightTheme,
      //darkTheme: yaru.darkTheme,
      localizationsDelegates: [
        ChildCareLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        //GlobalCupertinoLocalizations.delegate,
        CountryLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
        Locale('fr', 'CH'),
      ],
      localeListResolutionCallback: (locales, supportedLocales) {
        if (locales != null) {
          for (var locale in locales) {
            var supportedLocale = supportedLocales.where((element) => element.languageCode == locale.languageCode && element.countryCode == locale.countryCode);
            if (supportedLocale.isNotEmpty) {
              return supportedLocale.first;
            }
            supportedLocale = supportedLocales.where((element) => element.languageCode == locale.languageCode);
            if (supportedLocale.isNotEmpty) {
              return supportedLocale.first;
            }
          }
        }
        return null;
      },
      routes: {
        '/': (context) => const HomePage(),
        '/entries': (context) => ChangeNotifierProvider(create: (context) => EntryModel(), child: const EntriesPage()),
        '/backup': (context) => const BackupAndRestorePage(),
      },
      onGenerateTitle: (context) => ChildCareLocalizations.of(context).t('Child Care'),
    );
  }
}
