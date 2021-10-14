import 'package:childcare2/app.dart';
import 'package:childcare2/utils/version_utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  VersionUtils.packageInfo = packageInfo;

  runApp(ChildCareApp());
}
