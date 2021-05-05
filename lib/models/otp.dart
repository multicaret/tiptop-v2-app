import 'package:tiptop_v2/models/user.dart';

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
