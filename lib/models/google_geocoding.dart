import 'dart:convert';

import 'enums.dart';
import 'models.dart';

GoogleGeocodeResponse geocodeResponseFromJson(String str) => GoogleGeocodeResponse.fromJson(json.decode(str));

class GoogleGeocodeResponse {
  List<Result> results;
  GoogleResponseStatus status;

  GoogleGeocodeResponse({
    this.results,
    this.status,
  });

  factory GoogleGeocodeResponse.fromJson(Map<String, dynamic> json) => GoogleGeocodeResponse(
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        status: googleResponseStatusValues.map[json["status"]],
      );
}

class Result {
  List<AddressComponent> addressComponents;
  String formattedAddress;
  Geometry geometry;
  String placeId;
  List<String> types;

  Result({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.types,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: List<AddressComponent>.from(json["address_components"].map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
        types: List<String>.from(json["types"].map((x) => x)),
      );
}

class AddressComponent {
  String longName;
  String shortName;
  List<String> types;

  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: List<String>.from(json["types"].map((x) => x)),
      );
}

class Geometry {
  Location location;
  String locationType;
  Viewport viewport;

  Geometry({
    this.location,
    this.locationType,
    this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
        locationType: json["location_type"],
        viewport: Viewport.fromJson(json["viewport"]),
      );
}

class Location {
  double lat;
  double lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );
}

class Viewport {
  Location northeast;
  Location southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
      );
}
