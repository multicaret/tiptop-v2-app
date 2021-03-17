import 'dart:convert';

import 'package:tiptop_v2/models/user.dart';

OTPDataResponse otpFromJson(String str) => OTPDataResponse.fromJson(json.decode(str));

String otpToJson(OTPDataResponse data) => json.encode(data.toJson());

class OTPDataResponse {
  OTPDataResponse({
    this.otpData,
    this.errors,
    this.message,
    this.status,
  });

  OTPData otpData;
  String errors;
  String message;
  int status;

  factory OTPDataResponse.fromJson(Map<String, dynamic> json) => OTPDataResponse(
        otpData: json["data"] == null ? null : OTPData.fromJson(json["data"]),
        errors: json["errors"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": otpData.toJson(),
        "errors": errors,
        "message": message,
        "status": status,
      };
}

class OTPData {
  OTPData({
    this.deepLink,
    this.reference,
  });

  String deepLink;
  String reference;

  factory OTPData.fromJson(Map<String, dynamic> json) => OTPData(
        deepLink: json["deeplink"],
        reference: json["reference"],
      );

  Map<String, dynamic> toJson() => {
        "deeplink": deepLink,
        "reference": reference,
      };
}

OTPValidationDataResponse otpValidationDataResponseFromJson(String str) => OTPValidationDataResponse.fromJson(json.decode(str));

String otpValidationDataResponseToJson(OTPValidationDataResponse data) => json.encode(data.toJson());

class OTPValidationDataResponse {
  OTPValidationDataResponse({
    this.otpValidationData,
    this.errors,
    this.message,
    this.status,
  });

  OTPValidationData otpValidationData;
  String errors;
  String message;
  int status;

  factory OTPValidationDataResponse.fromJson(Map<String, dynamic> json) => OTPValidationDataResponse(
        otpValidationData: json["data"] == null ? null : OTPValidationData.fromJson(json["data"]),
        errors: json["errors"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": otpValidationData.toJson(),
        "errors": errors,
        "message": message,
        "status": status,
      };
}

class OTPValidationData {
  OTPValidationData({
    this.newUser,
    this.user,
    this.accessToken,
    this.validationStatus,
    this.sessionId,
    this.appPlatform,
  });

  bool newUser;
  User user;
  String accessToken;
  bool validationStatus;
  String sessionId;
  String appPlatform;

  factory OTPValidationData.fromJson(Map<String, dynamic> json) => OTPValidationData(
        newUser: json["newUser"],
        user: User.fromJson(json["user"]),
        accessToken: json["accessToken"],
        validationStatus: json["validationStatus"],
        sessionId: json["sessionId"],
        appPlatform: json["appPlatform"],
      );

  Map<String, dynamic> toJson() => {
        "newUser": newUser,
        "user": user.toJson(),
        "accessToken": accessToken,
        "validationStatus": validationStatus,
        "sessionId": sessionId,
        "appPlatform": appPlatform,
      };
}
