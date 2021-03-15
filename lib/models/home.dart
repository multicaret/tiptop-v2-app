import 'dart:convert';

import 'package:tiptop_v2/models/models.dart';

import 'package:tiptop_v2/models/models.dart';

import 'package:tiptop_v2/models/models.dart';

import 'category.dart';

HomeDataResponse homeDataResponseFromJson(String str) => HomeDataResponse.fromJson(json.decode(str));

String homeDataResponseToJson(HomeDataResponse data) => json.encode(data.toJson());

class HomeDataResponse {
  HomeDataResponse({
    this.homeData,
    this.errors,
    this.message,
    this.status,
  });

  HomeData homeData;
  String errors;
  String message;
  int status;

  factory HomeDataResponse.fromJson(Map<String, dynamic> json) => HomeDataResponse(
    homeData: json["data"] == null ? null : HomeData.fromJson(json["data"]),
    errors: json["errors"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": homeData.toJson(),
    "errors": errors,
    "message": message,
    "status": status,
  };
}

class HomeData {
  HomeData({
    this.addresses,
    this.slides,
    this.estimatedArrivalTime,
    this.branch,
    this.distance,
    this.hasAvailableBranchesNow,
    this.categories,
  });

  List<dynamic> addresses;
  List<dynamic> slides;
  EstimatedArrivalTime estimatedArrivalTime;
  Branch branch;
  dynamic distance;
  bool hasAvailableBranchesNow;
  List<Category> categories;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    addresses: List<dynamic>.from(json["addresses"].map((x) => x)),
    slides: List<dynamic>.from(json["slides"].map((x) => x)),
    estimatedArrivalTime: EstimatedArrivalTime.fromJson(json["estimated_arrival_time"]),
    branch: Branch.fromJson(json["branch"]),
    distance: json["distance"],
    hasAvailableBranchesNow: json["hasAvailableBranchesNow"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "addresses": List<dynamic>.from(addresses.map((x) => x)),
    "slides": List<dynamic>.from(slides.map((x) => x)),
    "estimated_arrival_time": estimatedArrivalTime.toJson(),
    "branch": branch.toJson(),
    "distance": distance,
    "hasAvailableBranchesNow": hasAvailableBranchesNow,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class EstimatedArrivalTime {
  EstimatedArrivalTime({
    this.value,
    this.unit,
  });

  String value;
  String unit;

  factory EstimatedArrivalTime.fromJson(Map<String, dynamic> json) => EstimatedArrivalTime(
    value: json["value"],
    unit: json["unit"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "unit": unit,
  };
}

class Branch {
  Branch({
    this.id,
    this.regionId,
    this.cityId,
    this.minimumOrder,
    this.underMinimumOrderDeliveryFee,
    this.fixedDeliveryFee,
    this.primaryPhoneNumber,
    this.secondaryPhoneNumber,
    this.whatsappPhoneNumber,
    this.latitude,
    this.longitude,
    this.chain,
  });

  int id;
  int regionId;
  int cityId;
  IntRawStringFormatted minimumOrder;
  IntRawStringFormatted underMinimumOrderDeliveryFee;
  IntRawStringFormatted fixedDeliveryFee;
  String primaryPhoneNumber;
  String secondaryPhoneNumber;
  String whatsappPhoneNumber;
  String latitude;
  String longitude;
  Chain chain;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json["id"],
    regionId: json["regionId"],
    cityId: json["cityId"],
    minimumOrder: IntRawStringFormatted.fromJson(json["minimumOrder"]),
    underMinimumOrderDeliveryFee: IntRawStringFormatted.fromJson(json["underMinimumOrderDeliveryFee"]),
    fixedDeliveryFee: IntRawStringFormatted.fromJson(json["fixedDeliveryFee"]),
    primaryPhoneNumber: json["primaryPhoneNumber"],
    secondaryPhoneNumber: json["secondaryPhoneNumber"],
    whatsappPhoneNumber: json["whatsappPhoneNumber"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    chain: Chain.fromJson(json["chain"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "regionId": regionId,
    "cityId": cityId,
    "minimumOrder": minimumOrder.toJson(),
    "underMinimumOrderDeliveryFee": underMinimumOrderDeliveryFee.toJson(),
    "fixedDeliveryFee": fixedDeliveryFee.toJson(),
    "primaryPhoneNumber": primaryPhoneNumber,
    "secondaryPhoneNumber": secondaryPhoneNumber,
    "whatsappPhoneNumber": whatsappPhoneNumber,
    "latitude": latitude,
    "longitude": longitude,
    "chain": chain.toJson(),
  };
}

class Chain {
  Chain({
    this.id,
    this.regionId,
    this.cityId,
    this.currencyId,
    this.primaryPhoneNumber,
    this.secondaryPhoneNumber,
    this.whatsappPhoneNumber,
    this.primaryColor,
    this.secondaryColor,
    this.numberOfItemsOnMobileGridView,
    this.media,
  });

  int id;
  int regionId;
  int cityId;
  int currencyId;
  String primaryPhoneNumber;
  String secondaryPhoneNumber;
  String whatsappPhoneNumber;
  String primaryColor;
  String secondaryColor;
  int numberOfItemsOnMobileGridView;
  Media media;

  factory Chain.fromJson(Map<String, dynamic> json) => Chain(
    id: json["id"],
    regionId: json["regionId"],
    cityId: json["cityId"],
    currencyId: json["currencyId"],
    primaryPhoneNumber: json["primaryPhoneNumber"],
    secondaryPhoneNumber: json["secondaryPhoneNumber"],
    whatsappPhoneNumber: json["whatsappPhoneNumber"],
    primaryColor: json["primaryColor"],
    secondaryColor: json["secondaryColor"],
    numberOfItemsOnMobileGridView: json["numberOfItemsOnMobileGridView"],
    media: Media.fromJson(json["media"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "regionId": regionId,
    "cityId": cityId,
    "currencyId": currencyId,
    "primaryPhoneNumber": primaryPhoneNumber,
    "secondaryPhoneNumber": secondaryPhoneNumber,
    "whatsappPhoneNumber": whatsappPhoneNumber,
    "primaryColor": primaryColor,
    "secondaryColor": secondaryColor,
    "numberOfItemsOnMobileGridView": numberOfItemsOnMobileGridView,
    "media": media.toJson(),
  };
}

class Media {
  Media({
    this.logo,
    // this.cover,
    this.gallery,
  });

  String logo;
  //Todo: uncomment when filled
  // String cover;
  List<dynamic> gallery;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    logo: json["logo"],
    // cover: json["cover"],
    gallery: List<dynamic>.from(json["gallery"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "logo": logo,
    // "cover": cover,
    "gallery": List<dynamic>.from(gallery.map((x) => x)),
  };
}