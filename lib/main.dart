import 'package:childcare2/app.dart';
import 'package:childcare2/utils/database_utils.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseUtils.getDatabase();
  runApp(const ChildCareApp());
}
