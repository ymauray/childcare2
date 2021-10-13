import 'dart:io';

import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/model/entry_model.dart';
import 'package:childcare2/pages/backup_and_restore.dart';
import 'package:childcare2/pages/entries_page.dart';
import 'package:childcare2/pages/home_page.dart';
import 'package:childcare2/pages/settings_page.dart';
import 'package:childcare2/utils/database_utils.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class ChildCareApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = DatabaseUtils.getDatabase()
      .then((_) {
        return FlutterLibphonenumber().init();
      })
      .then((_) => Firebase.initializeApp())
      .then((snapshot) {
        if (kDebugMode) {
          FirebaseAuth.instance.useAuthEmulator(Platform.isAndroid ? "10.0.2.2" : "localhost", 9099);
        }
        return snapshot;
      });

  ChildCareApp({Key? key}) : super(key: key);

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
        '/': (context) => FutureBuilder(
              future: _fbApp,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong.");
                } else if (snapshot.hasData) {
                  return const HomePage();
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
        '/entries': (context) => ChangeNotifierProvider(create: (context) => EntryModel(), child: const EntriesPage()),
        '/settings': (context) => const SettingsPage(),
        '/backup': (context) => const BackupAndRestorePage(),
      },
      onGenerateTitle: (context) => ChildCareLocalizations.of(context).t('Child Care'),
    );
  }
}
