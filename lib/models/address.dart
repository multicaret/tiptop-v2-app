import 'models.dart';

class CreateAddressResponseData {
  CreateAddressResponseData({
    this.createAddressData,
    this.errors,
    this.message,
    this.status,
  });

  CreateAddressData createAddressData;
  String errors;
  String message;
  int status;

  factory CreateAddressResponseData.fromJson(Map<String, dynamic> json) => CreateAddressResponseData(
    createAddressData: json["data"] == null ? null : CreateAddressData.fromJson(json["data"]),
    errors: json["errors"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": createAddressData.toJson(),
    "errors": errors,
    "message": message,
    "status": status,
  };
}

class CreateAddressData {
  CreateAddressData({
    this.regions,
    this.cities,
    this.selectedRegion,
    this.selectedCity,
  });

  List<Region> regions;
  List<City> cities;
  Region selectedRegion;
  City selectedCity;

  factory CreateAddressData.fromJson(Map<String, dynamic> json) => CreateAddressData(
    regions: List<Region>.from(json["regions"].map((x) => Region.fromJson(x))),
    cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
    selectedRegion: Region.fromJson(json["selectedRegion"]),
    selectedCity: City.fromJson(json["selectedCity"]),
  );

  Map<String, dynamic> toJson() => {
    "regions": List<dynamic>.from(regions.map((x) => x.toJson())),
    "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
    "selectedRegion": selectedRegion.toJson(),
    "selectedCity": selectedCity.toJson(),
  };
}