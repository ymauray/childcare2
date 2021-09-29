import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/widgets/entries.dart';
import 'package:childcare2/widgets/folder_form.dart';
import 'package:childcare2/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yaru/yaru.dart' as yaru;

class ChildCareApp extends StatelessWidget {
  const ChildCareApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: yaru.lightTheme,
      darkTheme: yaru.darkTheme,
      localizationsDelegates: [
        ChildCareLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      routes: {
        '/': (context) => const HomePage(),
        '/edit': (context) => const FolderForm(),
        '/entries': (context) => const Entries(),
      },
      onGenerateTitle: (context) => ChildCareLocalizations.of(context).t('Child Care'),
    );
  }
}
