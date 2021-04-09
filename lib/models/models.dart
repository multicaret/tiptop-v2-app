import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class StringRawStringFormatted {
  String raw;
  String formatted;

  StringRawStringFormatted({
    this.raw,
    this.formatted,
  });

  factory StringRawStringFormatted.fromJson(Map<String, dynamic> json) => StringRawStringFormatted(
        raw: json["raw"] == null ? null : json["raw"],
        formatted: json["formatted"] == null ? null : json["formatted"],
      );

  Map<String, dynamic> toJson() => {
        "raw": raw == null ? null : raw,
        "formatted": formatted == null ? null : formatted,
      };
}

class DoubleRawStringFormatted {
  double raw;
  String formatted;

  DoubleRawStringFormatted({
    this.raw,
    this.formatted,
  });

  factory DoubleRawStringFormatted.fromJson(Map<String, dynamic> json) => DoubleRawStringFormatted(
        raw: json["raw"] == null ? null : json["raw"].toDouble(),
        formatted: json["formatted"] == null ? null : json["formatted"],
      );

  Map<String, dynamic> toJson() => {
        "raw": raw == null ? null : raw,
        "formatted": formatted == null ? null : formatted,
      };
}

class IntRawStringFormatted {
  int raw;
  String formatted;

  IntRawStringFormatted({
    this.raw,
    this.formatted,
  });

  factory IntRawStringFormatted.fromJson(Map<String, dynamic> json) => IntRawStringFormatted(
        raw: json["raw"] == null ? null : json["raw"],
        formatted: json["formatted"] == null ? null : json["formatted"],
      );

  Map<String, dynamic> toJson() => {
        "raw": raw == null ? null : raw,
        "formatted": formatted == null ? null : formatted,
      };
}

class DoubleRawIntFormatted {
  double raw;
  String formatted;

  DoubleRawIntFormatted({
    this.raw,
    this.formatted,
  });

  factory DoubleRawIntFormatted.fromJson(Map<String, dynamic> json) => DoubleRawIntFormatted(
        raw: json["raw"] == null ? null : json["raw"].toDouble(),
        formatted: json["formatted"] == null ? null : json["formatted"],
      );

  Map<String, dynamic> toJson() => {
        "raw": raw == null ? null : raw,
        "formatted": formatted == null ? null : formatted,
      };
}

class EdAt {
  String formatted;
  String diffForHumans;
  int timestamp;

  EdAt({
    this.formatted,
    this.diffForHumans,
    this.timestamp,
  });

  factory EdAt.fromJson(Map<String, dynamic> json) => EdAt(
        formatted: json["formatted"] == null ? null : json["formatted"],
        diffForHumans: json["diffForHumans"] == null ? null : json["diffForHumans"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "formatted": formatted == null ? null : formatted,
        "diffForHumans": diffForHumans == null ? null : diffForHumans,
        "timestamp": timestamp == null ? null : timestamp,
      };
}

class Media {
  Media({
    this.logo,
    this.cover,
    this.coverThumbnail,
    this.coverFull,
    this.gallery,
  });

  String logo;
  String cover;
  String coverThumbnail;
  String coverFull;
  List<Gallery> gallery;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        logo: json["logo"],
        cover: json["cover"],
        coverThumbnail: json["coverThumbnail"],
        coverFull: json["coverFull"],
        gallery: List<Gallery>.from(json["gallery"].map((x) => Gallery.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "logo": logo,
        "cover": cover,
        "coverThumbnail": coverThumbnail,
        "coverFull": coverFull,
        "gallery": List<dynamic>.from(gallery.map((x) => x.toJson())),
      };
}

class City {
  City({
    this.id,
    this.name,
    this.nameEnglish,
    this.description,
    this.code,
    this.country,
    this.region,
    this.timezone,
    this.population,
    this.latitude,
    this.longitude,
  });

  int id;
  String name;
  String nameEnglish;
  dynamic description;
  dynamic code;
  Country country;
  Region region;
  Timezone timezone;
  dynamic population;
  int latitude;
  int longitude;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        nameEnglish: json["nameEnglish"],
        description: json["description"],
        code: json["code"],
        country: Country.fromJson(json["country"]),
        region: Region.fromJson(json["region"]),
        timezone: Timezone.fromJson(json["timezone"]),
        population: json["population"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nameEnglish": nameEnglish,
        "description": description,
        "code": code,
        "country": country.toJson(),
        "region": region.toJson(),
        "timezone": timezone.toJson(),
        "population": population,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Country {
  Country({
    this.id,
    this.name,
    this.nameEnglish,
    this.phoneCode,
    this.alpha2Code,
    this.alpha3Code,
    this.flagUrl,
  });

  int id;
  String name;
  String nameEnglish;
  String alpha2Code;
  String alpha3Code;
  String phoneCode;
  String flagUrl;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        nameEnglish: json["nameEnglish"],
        alpha2Code: json["alpha2Code"],
        alpha3Code: json["alpha3Code"],
        phoneCode: json["phoneCode"],
        flagUrl: json["flagUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nameEnglish": nameEnglish,
        "alpha2Code": alpha2Code,
        "alpha3Code": alpha3Code,
        "phoneCode": phoneCode,
        "flagUrl": flagUrl,
      };
}

class Currency {
  Currency({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.rate,
    this.decimalSeparator,
    this.thousandsSeparator,
    this.isSymbolAfter,
  });

  int id;
  String name;
  String code;
  String symbol;
  double rate;
  String decimalSeparator;
  String thousandsSeparator;
  bool isSymbolAfter;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        symbol: json["symbol"],
        rate: json["rate"].toDouble(),
        decimalSeparator: json["decimalSeparator"],
        thousandsSeparator: json["thousandsSeparator"],
        isSymbolAfter: json["isSymbolAfter"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "symbol": symbol,
        "rate": rate,
        "decimalSeparator": decimalSeparator,
        "thousandsSeparator": thousandsSeparator,
        "isSymbolAfter": isSymbolAfter,
      };
}

class Timezone {
  Timezone({
    this.id,
    this.name,
    this.utcOffset,
    this.dstOffset,
  });

  int id;
  String name;
  int utcOffset;
  int dstOffset;

  factory Timezone.fromJson(Map<String, dynamic> json) => Timezone(
        id: json["id"],
        name: json["name"],
        utcOffset: json["utcOffset"],
        dstOffset: json["dstOffset"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "utcOffset": utcOffset,
        "dstOffset": dstOffset,
      };
}

class Region {
  Region({
    this.id,
    this.name,
    this.nameEnglish,
    this.code,
  });

  int id;
  String name;
  String nameEnglish;
  String code;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"],
        name: json["name"],
        nameEnglish: json["nameEnglish"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nameEnglish": nameEnglish,
        "code": code,
      };
}

class MobileApp {
  MobileApp({
    this.device,
    this.version,
    this.buildNumber,
  });

  Device device;
  String version;
  dynamic buildNumber;

  factory MobileApp.fromJson(Map<String, dynamic> json) => MobileApp(
        device: Device.fromJson(json["device"]),
        version: json["version"],
        buildNumber: json["buildNumber"],
      );

  Map<String, dynamic> toJson() => {
        "device": device.toJson(),
        "version": version,
        "buildNumber": buildNumber,
      };
}

class Device {
  Device({
    this.uuid,
    this.model,
    this.serial,
    this.version,
    this.platform,
    this.manufacturer,
  });

  String uuid;
  String model;
  String serial;
  String version;
  String platform;
  String manufacturer;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        uuid: json["uuid"],
        model: json["model"],
        serial: json["serial"],
        version: json["version"],
        platform: json["platform"],
        manufacturer: json["manufacturer"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "model": model,
        "serial": serial,
        "version": version,
        "platform": platform,
        "manufacturer": manufacturer,
      };
}

class Rating {
  Rating({
    this.average,
    this.countRaw,
    this.countFormatted,
  });

  String average;
  int countRaw;
  String countFormatted;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        average: json["average"],
        countRaw: json["countRaw"],
        countFormatted: json["countFormatted"],
      );

  Map<String, dynamic> toJson() => {
        "average": average,
        "countRaw": countRaw,
        "countFormatted": countFormatted,
      };
}

class Settings {
  Settings({
    this.notifications,
  });

  Notifications notifications;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        notifications: Notifications.fromJson(json["notifications"]),
      );

  Map<String, dynamic> toJson() => {
        "notifications": notifications.toJson(),
      };
}

class Notifications {
  Notifications({
    this.db,
    this.mail,
    this.pushWebAll,
    this.pushMobileAds,
    this.pushMobileAll,
  });

  int db;
  int mail;
  int pushWebAll;
  int pushMobileAds;
  int pushMobileAll;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        db: json["db"],
        mail: json["mail"],
        pushWebAll: json["push_web_all"],
        pushMobileAds: json["push_mobile_ads"],
        pushMobileAll: json["push_mobile_all"],
      );

  Map<String, dynamic> toJson() => {
        "db": db,
        "mail": mail,
        "push_web_all": pushWebAll,
        "push_mobile_ads": pushMobileAds,
        "push_mobile_all": pushMobileAll,
      };
}

class Gallery {
  Gallery({
    this.id,
    this.name,
    this.type,
    this.size,
    this.file,
    this.thumbnail,
  });

  int id;
  String name;
  String type;
  int size;
  String file;
  String thumbnail;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        size: json["size"],
        file: json["file"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "size": size,
        "file": file,
        "thumbnail": thumbnail,
      };
}

class Language {
  int id;
  String title;
  String logo;
  String locale;
  String countryCode;

  Language({
    this.id,
    this.title,
    this.logo,
    this.locale,
    this.countryCode,
  });
}

class Restaurant {
  Restaurant({this.id, this.title, this.cover, this.discountValue});

  int id;
  String title;
  String cover;
  String discountValue;
}

dynamic handleErrors(errors) {
  if (errors == null) return errors;
  if (errors is String) return errors;
  Map<String, dynamic> formattedErrors = {};
  if (errors is Map) {
    errors.forEach((index, error) {
      formattedErrors[index] = List<String>.from(errors[index].map((x) => x));
    });
  }
  return formattedErrors;
}

class DialogAction {
  final String text;
  final Color buttonColor;
  final Color buttonTextColor;
  final dynamic popValue;
  final Function onTap;

  DialogAction({
    @required this.text,
    this.buttonColor = AppColors.primary,
    this.buttonTextColor = AppColors.white,
    this.popValue,
    this.onTap,
  });
}

class PaymentSummaryTotal {
  final String title;
  final String value;
  final bool isSavedAmount;
  final bool isGrandTotal;
  final bool isDiscounted;

  PaymentSummaryTotal({
    @required this.title,
    @required this.value,
    this.isSavedAmount = false,
    this.isGrandTotal = false,
    this.isDiscounted = false,
  });
}
