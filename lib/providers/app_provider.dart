import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  String get dir => _appLocale == Locale('ar') || _appLocale == Locale('fa') ? 'rtl' : 'ltr';

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

  static const DOMAIN = 'https://titan.trytiptop.app/';
  final Map<String, String> headers = {"accept": "application/json", "content-type": "application/json"};

  String token;

  Map<String, String> get authHeader {
    var myHeader = headers;
    myHeader.addAll({"Authorization": "Bearer " + token});
    return myHeader;
  }

  Future<String> endpointRoot() async {
    var locale = await this.fetchLocale();
    String localeCode = locale.toString() == 'fa' ? 'ku' : locale.toString();
    return DOMAIN + localeCode + '/api/v1/';
  }

  Future<dynamic> get({
    @required String endpoint,
    Map<String, String> body,
    bool withToken = false,
  }) async {
    try {
      final root = await this.endpointRoot();
      print("root");
      print(root);
      Uri uri = Uri.parse(root + endpoint);
      uri = uri.replace(queryParameters: body);
      print("uri");
      print(uri);
      final response = await http.get(uri, headers: withToken ? authHeader : headers);

      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> post({
    @required String endpoint,
    Map<String, String> params,
    Map<String, dynamic> body,
    bool withToken = false,
  }) async {
    try {
      final root = await this.endpointRoot();
      Uri uri = Uri.parse(root + endpoint);
      uri = uri.replace(queryParameters: params);
      print("uri");
      print(uri);
      http.Response response = await http.post(uri, body: json.encode(body), headers: withToken ? authHeader : headers);
      final dynamic responseData = json.decode(response.body) as Map<dynamic, dynamic>;

      return responseData;
    } catch (error) {
      throw error;
    }
  }
}