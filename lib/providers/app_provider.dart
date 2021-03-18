import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiptop_v2/models/user.dart';

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

  bool get isRTL => _appLocale == Locale('ar') || _appLocale == Locale('fa');

  fetchLocale() async {
    var languageCode = storageActions.getData(key: 'language_code');
    if (languageCode == null) {
      print('locale not selected yet!');
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
      Uri uri = Uri.parse(root + endpoint);
      uri = uri.replace(queryParameters: body);
      print("uri");
      print(uri);
      final response = await http.get(uri, headers: withToken && token != null ? authHeader : headers);

      if (response.statusCode == 401) {
        if (token != null) {
          print('Sending authenticated request with expired token! Logging out...');
          logout();
          return;
        } else {
          print('Sending authenticated request without logging in!');
          return 401;
        }
      }

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
      http.Response response = await http.post(uri, body: json.encode(body), headers: withToken && token != null ? authHeader : headers);
      final dynamic responseData = json.decode(response.body) as Map<dynamic, dynamic>;
      if (response.statusCode == 401) {
        if (token != null) {
          print('Sending authenticated request with expired token! Logging out...');
          logout();
          return;
        } else {
          print('Sending authenticated request without logging in!');
          return 401;
        }
      }
      return responseData;
    } catch (error) {
      throw error;
    }
  }

  User authUser;
  int userId;
  String token;

  bool get isAuth => token != null;

  Future<void> updateUserData(User _authUser, String accessToken) async {
    print('accessToken');
    print(accessToken);
    authUser = _authUser;
    userId = authUser.id;
    token = accessToken;
    final userData = {
      'accessToken': token,
      'userId': userId,
      'data': json.encode(authUser.toJson()),
    };
    storageActions.save(key: 'userData', data: userData).then((_) {
      print('Successfully saved user data');
    }).catchError((error) {
      print('Error saving user data to local storage');
      throw error;
    });
  }

  Future<void> autoLogin() async {
    print("Trying to auto login....");
    var checkUserDataKey = storageActions.checkKey(key: 'userData');
    if (!checkUserDataKey) {
      print('Not logged in! (No local storage key)');
      return;
    }
    var userDataString = await storageActions.getDataType(key: 'userData', type: String);
    final responseData = json.decode(userDataString) as Map<String, dynamic>;
    authUser = User.fromJson(json.decode(responseData['data']));
    userId = LocalStorage.userId = responseData['userId'];
    token = responseData['accessToken'];
    if (token != null) {
      print('Token found in local storage, auto login successful!');
      print('User id: ${authUser.id}, username: ${authUser.name}');
      print('token');
      print(token);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    token = null;
    userId = null;
    await storageActions.deleteData(key: 'userData');
    print('Deleted user data and logged out');
    notifyListeners();
  }

  void isAttemptingRequestWithExpiredToken() {}
}
