import 'package:package_info_plus/package_info_plus.dart';

class VersionUtils {
  static PackageInfo? packageInfo;

  static String get appName => packageInfo?.appName ?? '';
  static String get packageName => packageInfo?.packageName ?? '';
  static String get version => packageInfo?.version ?? '';
  static String get buildNumber => packageInfo?.buildNumber ?? '';
}
