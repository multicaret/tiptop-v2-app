import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/otp.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class OTPProvider with ChangeNotifier {
  String reference;
  String deepLink;
  bool validationStatus;
  bool isNewUser;
  OTPDataResponse otpInitDataResponse;
  OTPValidationDataResponse otpValidationDataResponse;
  OTPValidationData otpValidationData;
  DateTime validationDate;
  List<Country> countries = [];
  List<Region> regions = [];
  List<City> cities = [];

  Future<void> fetchAndSetCountries() async {
    final endpoint = 'countries';
    final responseData = await AppProvider().get(endpoint: endpoint);
    if (responseData["data"] == null || responseData["status"] != 200) {
      throw HttpException(title: 'Error', message: responseData["message"] ?? 'Unknown');
    }
    List<Country> _countries = List<Country>.from(responseData["data"].map((x) => Country.fromJson(x)));
    countries = _countries.where((country) => country.phoneCode != null).toList();
  }

  Future<void> initOTPValidation(String method) async {
    final endpoint = 'otp/init-validation?method=$method';
    final responseData = await AppProvider().get(endpoint: endpoint);
    otpInitDataResponse = OTPDataResponse.fromJson(responseData);

    if (otpInitDataResponse.otpData == null || otpInitDataResponse.status != 200) {
      throw HttpException(title: 'Error', message: otpInitDataResponse.message);
    }

    deepLink = otpInitDataResponse.otpData.deepLink;
    reference = otpInitDataResponse.otpData.reference;

    print('deepLink: $deepLink');
    print('reference: $reference');
    notifyListeners();
  }

  Future<void> checkOTPValidation(AppProvider appProvider, String reference) async {
    print('reference in check: $reference');
    final endpoint = 'otp/check-validation/$reference';
    final mobileAppDetails = await appProvider.loadMobileAppDetails();
    final Map<String, String> body = {
      'mobile_app_details': json.encode(mobileAppDetails),
    };

    final responseData = await AppProvider().get(
      endpoint: endpoint,
      body: body,
    );
    print('responseData');
    print(responseData);
    otpValidationDataResponse = OTPValidationDataResponse.fromJson(responseData);
    if (otpValidationDataResponse.otpValidationData == null || otpValidationDataResponse.status != 200) {
      throw HttpException(title: 'Error', message: otpInitDataResponse.message, errors: otpValidationDataResponse.errors);
    }
    otpValidationData = otpValidationDataResponse.otpValidationData;
    validationStatus = otpValidationData.validationStatus;
    isNewUser = otpValidationData.newUser;

    appProvider.updateUserData(otpValidationData.user, otpValidationData.accessToken);

    print('validationStatus: $validationStatus');
    notifyListeners();
  }

  Future<void> initSMSOTPAndSendCode(String phoneCountryCode, String phoneNumber) async {
    final endpoint = 'otp/sms-send';
    final responseData = await AppProvider().post(endpoint: endpoint, body: {
      'phone_country_code': phoneCountryCode,
      'phone_number': phoneNumber,
    });
    print('initSMSOTPAndSendCode responseData');
    print(responseData);

    otpInitDataResponse = OTPDataResponse.fromJson(responseData);

    reference = otpInitDataResponse.otpData.reference;

    print('SMS reference: $reference');
    notifyListeners();
  }

  Future<void> checkOTPSMSValidation(AppProvider appProvider, Map<String, dynamic> smsOTPData) async {
    final endpoint = 'otp/sms-validate';
    final responseData = await AppProvider().post(endpoint: endpoint, body: smsOTPData);
    print('checkOTPSMSValidation responseData');
    print(responseData);
    otpValidationDataResponse = OTPValidationDataResponse.fromJson(responseData);

    if (otpValidationDataResponse.otpValidationData == null || otpValidationDataResponse.status != 200) {
      throw HttpException(title: 'Error', message: otpInitDataResponse.message);
    }

    otpValidationData = otpValidationDataResponse.otpValidationData;
    validationStatus = otpValidationData.validationStatus;
    isNewUser = otpValidationData.newUser;

    appProvider.updateUserData(otpValidationData.user, otpValidationData.accessToken);

    print('validationStatus: $validationStatus');
    notifyListeners();
  }

  Future<dynamic> createEditProfileRequest(AppProvider appProvider) async {
    final endpoint = 'profile/edit';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: true);
    if (responseData == 401) {
      return 401;
    }
    if (responseData["data"] == null || responseData["status"] != 200) {
      throw HttpException(title: 'Error', message: responseData["message"] ?? "Unknown");
    }
    regions = List<Region>.from(responseData["data"]["regions"].map((x) => Region.fromJson(x)));
    cities = List<City>.from(responseData["data"]["cities"].map((x) => City.fromJson(x)));
    notifyListeners();
  }
}
