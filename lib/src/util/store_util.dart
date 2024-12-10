import 'package:shared_preferences/shared_preferences.dart';

class StoreUtil {
  StoreUtil._();

  static final shared = StoreUtil._();

  factory StoreUtil() => shared;

  late SharedPreferences _prefs;

  init(SharedPreferences sp) => _prefs = sp;

  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }
}
