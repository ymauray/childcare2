import 'dart:io';
import 'dart:math';

import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/utils/database_utils.dart';
import 'package:childcare2/utils/version_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = ChildCareLocalizations.of(context);
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          i18n.t('Settings'),
          style: TextStyle(color: t.colorScheme.onPrimary),
        ),
        backgroundColor: t.colorScheme.primary,
        iconTheme: IconThemeData(color: t.colorScheme.onPrimary),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    VersionUtils.appName,
                    style: t.textTheme.headline6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(VersionUtils.version + ' (' + VersionUtils.buildNumber + ')'),
                ),
                const Divider(),
                TextButton(
                  onPressed: () async {
                    const String namespace = "simple-child-care";
                    final String debugURL = Platform.isAndroid ? "http://10.0.2.2:9000?ns=$namespace" : "http://localhost:9000?ns=$namespace";
                    const String productionURL = "https://simple-child-care-default-rtdb.europe-west1.firebasedatabase.app/";
                    final String databaseURL = kDebugMode ? debugURL : productionURL;
                    DatabaseReference _testRef = FirebaseDatabase(databaseURL: databaseURL).reference().child("test");
                    _testRef.set("Hello world ${Random().nextInt(100)}");
                    await DatabaseUtils.deleteDatabase();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(i18n.t("Delete database")),
                          content: Text(i18n.t("Database successfully deleted.")),
                          actions: [
                            TextButton(
                              child: Text(i18n.t("OK")),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.trashAlt,
                        size: 2 * (t.iconTheme.size ?? 24),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(i18n.t("Delete database")),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
