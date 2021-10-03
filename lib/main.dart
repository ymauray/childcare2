import 'package:childcare2/app.dart';
import 'package:childcare2/utils/database_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseUtils.getDatabase();
  await FlutterLibphonenumber().init();
  runApp(const ChildCareApp());
}
