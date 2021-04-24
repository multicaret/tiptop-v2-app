import 'enums.dart';

class BootData {
  BootData({
    this.bootConfigs,
    this.defaultChannel,
  });

  BootConfigs bootConfigs;
  AppChannel defaultChannel;

  factory BootData.fromJson(Map<String, dynamic> json) => BootData(
        bootConfigs: BootConfigs.fromJson(json["bootConfigs"]),
        defaultChannel: appChannelValues.map[json["defaultChannel"]],
      );

  Map<String, dynamic> toJson() => {
        "id": bootConfigs.toJson(),
        "defaultChannel": appChannelValues.reverse[defaultChannel],
      };
}

class BootConfigs {
  BootConfigs({
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

  factory BootConfigs.fromJson(Map<String, dynamic> json) => BootConfigs(
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
