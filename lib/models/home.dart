import 'dart:convert';

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
  dynamic branch;
  dynamic distance;
  bool hasAvailableBranchesNow;
  List<Category> categories;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    addresses: List<dynamic>.from(json["addresses"].map((x) => x)),
    slides: List<dynamic>.from(json["slides"].map((x) => x)),
    estimatedArrivalTime: EstimatedArrivalTime.fromJson(json["estimated_arrival_time"]),
    branch: json["branch"],
    distance: json["distance"],
    hasAvailableBranchesNow: json["hasAvailableBranchesNow"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "addresses": List<dynamic>.from(addresses.map((x) => x)),
    "slides": List<dynamic>.from(slides.map((x) => x)),
    "estimated_arrival_time": estimatedArrivalTime.toJson(),
    "branch": branch,
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