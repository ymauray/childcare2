import 'dart:io';

import 'package:childcare2/app.dart';
import 'package:childcare2/model/settings.dart';
import 'package:childcare2/utils/database_utils.dart';
import 'package:childcare2/utils/version_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  VersionUtils.packageInfo = packageInfo;

  await DatabaseUtils.getDatabase();
  try {
    await settings.load();
  } on DatabaseException {
    /// Nothing to do
  }
  await FlutterLibphonenumber().init();
  await Firebase.initializeApp();
  if (kDebugMode) {
    FirebaseAuth.instance.useAuthEmulator(Platform.isAndroid ? "10.0.2.2" : "localhost", 9099);
  }

  runApp(const ChildCareApp());
}
