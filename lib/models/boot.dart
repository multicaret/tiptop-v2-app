// To parse this JSON data, do
//
//     final bootResponse = bootResponseFromJson(jsonString);

import 'dart:convert';

import 'enums.dart';
import 'models.dart';

BootResponse bootResponseFromJson(String str) => BootResponse.fromJson(json.decode(str));

String bootResponseToJson(BootResponse data) => json.encode(data.toJson());

class BootResponse {
  BootResponse({
    this.data,
    this.errors,
    this.message,
    this.status,
  });

  BootData data;
  String errors;
  String message;
  int status;

  factory BootResponse.fromJson(Map<String, dynamic> json) => BootResponse(
        data: json["data"] == null ? null : BootData.fromJson(json["data"]),
        errors: json["errors"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "errors": errors,
        "message": message,
        "status": status,
      };
}

class BootData {
  BootData({
    this.buildNumber,
    this.applicationType,
    this.platformType,
    this.updateMethod,
    this.data,
    this.dataTranslated,
  });

  int buildNumber;
  int applicationType;
  String platformType;
  int updateMethod;
  dynamic data;
  DataTranslated dataTranslated;

  factory BootData.fromJson(Map<String, dynamic> json) => BootData(
        buildNumber: json["buildNumber"],
        applicationType: json["applicationType"],
        platformType: json["platformType"],
        updateMethod: json["updateMethod"],
        data: json["data"],
        dataTranslated: DataTranslated.fromJson(json["dataTranslated"]),
      );

  Map<String, dynamic> toJson() => {
        "buildNumber": buildNumber,
        "applicationType": applicationType,
        "platformType": platformType,
        "updateMethod": updateMethod,
        "data": data,
        "dataTranslated": dataTranslated.toJson(),
      };
}

class DataTranslated {
  DataTranslated({
    this.dialog,
  });

  Dialog dialog;

  factory DataTranslated.fromJson(Map<String, dynamic> json) => DataTranslated(
        dialog: json["dialog"] == null ? null : Dialog.fromJson(json["dialog"]),
      );

  Map<String, dynamic> toJson() => {
        "dialog": dialog.toJson(),
      };
}

class Dialog {
  Dialog({
    this.title,
    this.content,
  });

  String title;
  String content;

  factory Dialog.fromJson(Map<String, dynamic> json) => Dialog(
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
      };
}

enum ForceUpdate { DISABLED, SOFT, HARD }

final forceUpdateValues = EnumValues({
  "0": ForceUpdate.DISABLED,
  "1": ForceUpdate.SOFT,
  "2": ForceUpdate.HARD,
});
