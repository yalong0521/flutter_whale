import 'package:package_info_plus/package_info_plus.dart';

class PackageUtil {
  PackageUtil._();

  static final PackageUtil shared = PackageUtil._();

  factory PackageUtil() => shared;

  late String _versionName;
  late String _versionCode;
  late String _appName;

  String get versionCode => _versionCode;

  String get versionName => _versionName;
  String get appName => _appName;

  Future init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _versionCode = packageInfo.buildNumber;
    _versionName = packageInfo.version;
    _appName = packageInfo.appName;
  }
}
