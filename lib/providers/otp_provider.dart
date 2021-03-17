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
    final body = {
      'phone_country_code': phoneCountryCode,
      'phone_number': phoneNumber,
    };

    final responseData = await AppProvider().get(
      endpoint: endpoint,
      body: body,
    );
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
