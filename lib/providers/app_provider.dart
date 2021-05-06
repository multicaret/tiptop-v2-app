import 'dart:convert';
import 'dart:io' show Platform, SocketException;

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:instabug_flutter/Instabug.dart';
import 'package:package_info/package_info.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/remote_config.dart';
import 'package:tiptop_v2/models/user.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

import 'local_storage.dart';

class AppProvider with ChangeNotifier {
  static const String GOOGLE_API_KEY = 'AIzaSyAJZv7luVqour5IPa4eFaKjYgRW0BGEpaw';

  // Boot config related
  RemoteConfigs remoteConfigs;

  bool _isForceUpdateEnabled = false;

  bool get isForceUpdateEnabled => _isForceUpdateEnabled;

  set isForceUpdateEnabled(bool isForceUpdateEnabled) {
    _isForceUpdateEnabled = isForceUpdateEnabled;
  }

  bool _isSoftUpdateEnabled = false;

  bool get isSoftUpdateEnabled => _isSoftUpdateEnabled;

  set isSoftUpdateEnabled(bool isSoftUpdateEnabled) {
    _isSoftUpdateEnabled = isSoftUpdateEnabled;
  }

  //  Location
  /*Todo: set these coordinates to be a proper place*/
  static double latitude;
  static double longitude;

  LocalStorage storageActions = LocalStorage.getActions();

  bool isFirstOpen = true;

  // Locale Related.
  bool localeSelected = false;
  static const String DEFAULT_LOCALE = 'en';
  Locale _appLocale = Locale(DEFAULT_LOCALE);

  Locale get appLocale => _appLocale ?? Locale(DEFAULT_LOCALE);

  String get dir => _appLocale == Locale('ar') || _appLocale == Locale('fa') ? 'rtl' : 'ltr';

  bool get isRTL => _appLocale == Locale('ar') || _appLocale == Locale('fa');

  set appLocale(value) {
    _appLocale = value;
  }

  List<Language> appLanguages = [
    Language(
      id: 1,
      title: 'English',
      locale: 'en',
      countryCode: 'US',
      logo: 'assets/images/en-flag.png',
    ),
    Language(
      id: 2,
      title: 'العربية',
      locale: 'ar',
      countryCode: '',
      logo: 'assets/images/ar-flag.png',
    ),
    Language(
      id: 3,
      title: 'كوردي',
      locale: 'fa',
      countryCode: 'US',
      logo: 'assets/images/ku-flag.png',
    ),
  ];

  // Auth Related.
  static const DOMAIN = 'https://trytiptop.app/';
  final Map<String, String> headers = {"accept": "application/json", "content-type": "application/json"};
  User authUser;
  int userId;
  String token;

  bool get isAuth => token != null;

  Map<String, String> get authHeader {
    var myHeader = headers;
    myHeader.addAll({"Authorization": "Bearer " + token});
    return myHeader;
  }

  Future<void> checkIfIsFirstOpen() async {
    var isFirstOpenKeyExists = storageActions.checkKey(key: 'is_first_open');
    isFirstOpen = !isFirstOpenKeyExists;
    print('First time opening the app: $isFirstOpen');
    if (isFirstOpen) {
      // await sendAppFirstVisitEvent();
      await storageActions.save(key: 'is_first_open', data: false);
      isFirstOpen = false;
    }
  }

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

/*  static final facebookAppEvents = FacebookAppEvents();
  Mixpanel mixpanel;

  Future<void> initMixpanel() async {
    mixpanel = await Mixpanel.init("6d5313743174278f57c324f5aadcc75c");
    mixpanel.setServerURL("https://api-eu.mixpanel.com");
  }*/

  bool isLocationPermissionGranted = false;

  bool noInternet = false;

  Future<void> bootActions() async {
    await fetchBootConfigurations();
    await fetchLocale();

    //Init Analytics
    // await initMixpanel();
    // await facebookAppEvents.setAdvertiserTracking(enabled: true);

    await checkIfIsFirstOpen();
    isLocationPermissionGranted = await getLocationPermissionStatus();

    await AddressesProvider().fetchSelectedAddress();
  }

  Future<void> changeLanguage(String localeString) async {
    _appLocale = Locale(localeString);
    await storageActions.save(key: 'language_code', data: localeString);
    localeSelected = true;
    notifyListeners();
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
    bool overrideStatusCheck = false,
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
        } else {
          print('Sending authenticated request without logging in!');
        }
        return 401;
      }

      final responseData = json.decode(response.body);
      // print(responseData);
      if (responseData["status"] != 200 && !overrideStatusCheck) {
        throw HttpException(title: 'Http Exception Error', message: getHttpExceptionMessage(responseData), errors: responseData["errors"]);
      }
      return responseData;
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> put({
    @required String endpoint,
    Map<String, String> params,
    Map<String, dynamic> body,
    bool withToken = false,
  }) async {
    this.post(endpoint: endpoint, body: body, params: params, withToken: withToken, isPut: true);
  }

  Future<dynamic> post({
    @required String endpoint,
    Map<String, String> params,
    Map<String, dynamic> body,
    bool withToken = false,
    bool isPut = false,
    bool overrideStatusCheck = false,
  }) async {
    try {
      final root = await this.endpointRoot();
      Uri uri = Uri.parse(root + endpoint);
      uri = uri.replace(queryParameters: params);
      print("uri");
      print(uri);
      http.Response response;
      if (!isPut) {
        response = await http.post(uri, body: json.encode(body), headers: withToken && token != null ? authHeader : headers);
      } else {
        response = await http.put(uri, body: json.encode(body), headers: withToken && token != null ? authHeader : headers);
      }
      final dynamic responseData = json.decode(response.body) as Map<dynamic, dynamic>;
      if (response.statusCode == 401) {
        if (token != null) {
          print('Sending authenticated request with expired token! Logging out...');
          logout();
        } else {
          print('Sending authenticated request without logging in!');
        }
        return 401;
      }
      if (responseData["status"] != 200 && !overrideStatusCheck) {
        throw HttpException(title: 'Http Exception Error', message: getHttpExceptionMessage(responseData), errors: responseData["errors"]);
      }
      return responseData;
    } catch (error) {
      throw error;
    }
  }

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

  Future<void> updateProfile(Map<String, dynamic> userData) async {
    try {
      final dynamic responseData = await this.post(
        withToken: true,
        endpoint: 'profile',
        body: userData,
      );
      User updatedUser = User.fromJson(responseData['data']['user']);
      updateUserData(updatedUser, token);

      print('name : ${updatedUser.name}');
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> autoLogin() async {
    print("Trying to auto login....");
    var checkUserDataKey = storageActions.checkKey(key: 'userData');
    if (!checkUserDataKey) {
      print('Not logged in! (No local storage key)');
      return;
    }
    var userDataString = await storageActions.getDataOfType(key: 'userData', type: String);
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
    await storageActions.deleteData(key: 'selected_address');
    print('Deleted user data and logged out');
    notifyListeners();
  }

  void isAttemptingRequestWithExpiredToken() {}

  void initInstaBug() {
    if (Platform.isIOS) {
      Instabug.start('82b5d29b0a4494bc9258e2562578037e', <InvocationEvent>[InvocationEvent.shake]);
    }
  }


  void initAdjust() {
    // Todo: init Adjust & send event with callback url params
    AdjustConfig adjustConfig = new AdjustConfig('yajo2k3wjp4w', AdjustEnvironment.sandbox);
    adjustConfig.logLevel = AdjustLogLevel.verbose;
    adjustConfig.launchDeferredDeeplink = true;
    adjustConfig.deferredDeeplinkCallback = (String uri) {
      print('[Adjust]: Received deferred deeplink: ' + uri);
    };
    Adjust.start(adjustConfig);

    // AdjustEvent adjustEvent = new AdjustEvent('2xbdbu');
    // adjustEvent.addCallbackParameter('status', 'Booted');
    // adjustEvent.setRevenue(6, 'EUR');
    // Adjust.trackEvent(adjustEvent);
  }

  Future<PackageInfo> getDeviceData() async {
    return await PackageInfo.fromPlatform();
  }

  Future<Map<String, dynamic>> initPlatformState() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
    }
    return deviceData;
  }

  Future<Map<String, dynamic>> loadMobileAppDetails() async {
    PackageInfo deviceData = await getDeviceData();
    Map<String, dynamic> platformState = await initPlatformState();

    return getMobileApp(deviceData, platformState);
  }

  Map<String, dynamic> mobileAppDetails;
  RemoteConfigsData remoteConfigsData;
  static AppChannel appDefaultChannel = AppChannel.MARKET;

  Future<void> fetchBootConfigurations() async {
    mobileAppDetails = await loadMobileAppDetails();
    final Map<String, String> body = {
      'build_number': mobileAppDetails['buildNumber'],
      'platform': mobileAppDetails['device']['platform'],
    };
    try {
      final responseData = await get(endpoint: 'remote-configs', body: body);
      noInternet = false;
      notifyListeners();
      if (responseData["data"] != null) {
        remoteConfigsData = RemoteConfigsData.fromJson(responseData["data"]);
        remoteConfigs = remoteConfigsData.configs;
        appDefaultChannel = remoteConfigsData.defaultChannel ?? AppChannel.MARKET;
      }
      print('selected channel is: $appDefaultChannel');
      if (remoteConfigs != null) {
        print("bootConfigs");
        print("remoteConfigs.updateMethod: ${remoteConfigs.updateMethod}");
        if (remoteConfigs.updateMethod == 2) {
          print("HARD");
          isForceUpdateEnabled = true;
        } else if (remoteConfigs.updateMethod == 1) {
          print("SOFT");
          isSoftUpdateEnabled = true;
        }
      }
    } on SocketException catch (_) {
      print('Thrown socket exception!');
      noInternet = true;
      notifyListeners();
    }
    /*bool isStorageCleared = storageActions.checkKey(key: 'storage_cleared');
    if (!isStorageCleared) {
      print('APP YIELD! your locale storage has been cleared!');
      LocalStorage().clear();
      // notifyListeners();
    }*/

    // notifyListeners();
  }

/*  Future<void> sendAppFirstVisitEvent() async {
    print('Sending app open event!');
    Map<String, dynamic> params = {
      'platform': mobileAppDetails['device']['platform'],
      'user_language': _appLocale.languageCode,
    };
    print('params');
    print(params);
    await facebookAppEvents.logEvent(
      name: 'first_visit',
      parameters: params,
    );
    mixpanel.track('first_visit', properties: params);
  }*/
}
