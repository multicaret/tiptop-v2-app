import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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

  Future<void> checkOTPValidation(AppProvider appProvider, String reference, String phoneCountryCode, String phoneNumber) async {
    print('reference in check: $reference');
    final endpoint = 'otp/check-validation/$reference';
    final mobileAppDetails = await appProvider.loadMobileAppDetails();
    final Map<String, String> body = {
      'phone_country_code': phoneCountryCode,
      'phone_number': phoneNumber,
      'mobile_app_details': json.encode(mobileAppDetails),
    };

    final responseData = await AppProvider().get(
      endpoint: endpoint,
      body: body,
    );
    otpValidationDataResponse = OTPValidationDataResponse.fromJson(responseData);
    print("@otpValidationDataResponse");
    print(otpValidationDataResponse);
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

  Future<void> sendOTPSms({String countryCode, String phoneCountryCode, String phoneNumber}) async {
    final endpoint = 'otp/sms-send';
    final responseData = await AppProvider().post(endpoint: endpoint, params: {
      'country_code': countryCode, // i.e: TR, IQ
      'phone_country_code': phoneCountryCode, // i.e: 90, 964
      'phone_number': phoneNumber,
    });
    otpInitDataResponse = OTPDataResponse.fromJson(responseData);

    reference = otpInitDataResponse.otpData.reference;

    print('SMS reference: $reference');
    notifyListeners();
  }

  Future<void> validateSMS(
    AppProvider appProvider,
    String countryCode,
    String phoneCountryCode,
    String phoneNumber,
    String code,
    String reference,
  ) async {
    final endpoint = 'otp/sms-validate';
    final mobileAppDetails = await appProvider.loadMobileAppDetails();
    final Map<String, String> body = {
      'country_code': countryCode, // i.e: TR, IQ
      'phone_country_code': phoneCountryCode, // i.e: 90, 964
      'phone_number': phoneNumber,
      'code': code,
      'reference': reference,
      'mobile_app_details': json.encode(mobileAppDetails),
    };
    final responseData = await AppProvider().post(endpoint: endpoint, params: body);

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
}
