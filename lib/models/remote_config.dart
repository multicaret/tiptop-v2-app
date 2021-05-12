import 'enums.dart';

class RemoteConfigsData {
  RemoteConfigsData({
    this.configs,
    this.defaultChannel,
  });

  RemoteConfigs configs;
  AppChannel defaultChannel;

  factory RemoteConfigsData.fromJson(Map<String, dynamic> json) => RemoteConfigsData(
        configs: json["configs"] == null
            ? null
            : RemoteConfigs.fromJson(json["configs"]),
        defaultChannel: appChannelValues.map[json["defaultChannel"]],
      );

  Map<String, dynamic> toJson() => {
        "id": configs.toJson(),
        "defaultChannel": appChannelValues.reverse[defaultChannel],
      };
}

class RemoteConfigs {
  RemoteConfigs({
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
  RemoteConfigUpdateMethod updateMethod;
  dynamic data;
  DataTranslated dataTranslated;

  factory RemoteConfigs.fromJson(Map<String, dynamic> json) => RemoteConfigs(
        buildNumber: json["buildNumber"],
        applicationType: json["applicationType"],
        platformType: json["platformType"],
        updateMethod: remoteConfigUpdateMethodValues.map[json["updateMethod"].toString()],
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
