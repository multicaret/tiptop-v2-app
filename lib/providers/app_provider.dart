import 'package:flutter/material.dart';

import 'local_storage.dart';

class AppProvider with ChangeNotifier {

  static const String GOOGLE_API_KEY = '';
  //  Location
  /*Todo: set these coordinates to be a proper place*/
  static double latitude = 41.017827;
  static double longitude = 28.971372;

  LocalStorage storageActions = LocalStorage.getActions();

  // Locale
  List<Map<String, String>> appLanguages = [
    {
      'title': 'English',
      'locale': 'en',
      'country_code': 'US',
      'flag': 'assets/images/en-flag.png',
    },
    {
      'title': 'العربية',
      'locale': 'ar',
      'country_code': '',
      'flag': 'assets/images/ar-flag.png',
    },
    {
      'title': 'كوردي',
      'locale': 'fa',
      'country_code': '',
      'flag': 'assets/images/ku-flag.png',
    },
  ];

  bool localeSelected = false;

  static const String DEFAULT_LOCALE = 'en';
  Locale _appLocale = Locale(DEFAULT_LOCALE);

  Locale get appLocal => _appLocale ?? Locale(DEFAULT_LOCALE);

  set appLocal(value) {
    _appLocale = value;
  }

  String get dir => _appLocale == Locale('ar') ? 'rtl' : 'ltr';

  fetchLocale() async {
    var languageCode = storageActions.getData(key: 'language_code');
    if (languageCode == null) {
      _appLocale = Locale(DEFAULT_LOCALE);
      localeSelected = false;
      return _appLocale;
    }
    localeSelected = true;
    _appLocale = Locale(languageCode);
    return _appLocale;
  }

  Future<void> changeLanguage(String localeString) async {
    _appLocale = Locale(localeString);
    await storageActions.save(key: 'language_code', data: localeString);
    localeSelected = true;
    notifyListeners();
  }
}