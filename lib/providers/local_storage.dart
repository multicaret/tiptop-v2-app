import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences _pref;
  static final LocalStorage _instance = LocalStorage();
  static int userId;

  static Future<SharedPreferences> _getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> isReady() async {
    var sharedPreferences = await _getSharedPreferencesInstance().whenComplete(() {});
    return Future(() => sharedPreferences != null);
  }

  static LocalStorage getActions() {
    return _instance;
  }

  LocalStorage() {
    _getSharedPreferencesInstance().then((onValue) => _pref = onValue);
  }

  Future<bool> deleteData({String key}) {
    return _pref.remove(key);
  }

  Future<bool> clear() {
    return _pref.clear();
  }

  Set<String> getKeys() {
    return _pref.getKeys();
  }

  bool checkKey({String key}) {
    return _pref.containsKey(key);
  }

  Future<bool> save({String key, dynamic data}) {
    if (key == 'userData') userId = data['userId'];
    if (data is String) {
      return _pref.setString(key, data);
    } else if (data is List<String>) {
      return _pref.setStringList(key, data);
    } else if (data is int) {
      return _pref.setInt(key, data);
    } else if (data is double) {
      return _pref.setDouble(key, data);
    } else if (data is bool) {
      return _pref.setBool(key, data);
    }
    var newData = json.encode(data);
    return _pref.setString(key, newData);
  }

  dynamic getData({String key}) {
    return _pref.get(key);
  }

  dynamic getDataType({String key, Type type}) {
    if (type is String) {
      return _pref.getString(key);
    } else if (type is List<String>) {
      return _pref.getStringList(key);
    } else if (type is int) {
      return _pref.getInt(key);
    } else if (type is double) {
      return _pref.getDouble(key);
    } else if (type is bool) {
      return _pref.getBool(key);
    }
    return _pref.get(key);
  }
}
