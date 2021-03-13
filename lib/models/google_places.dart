import 'dart:convert';

import 'models.dart';

GooglePlacesResponse googlePlacesResponseFromJson(String str) => GooglePlacesResponse.fromJson(json.decode(str));

class GooglePlacesResponse {
  List<Candidate> candidates;
  GoogleResponseStatus status;

  GooglePlacesResponse({
    this.candidates,
    this.status,
  });

  factory GooglePlacesResponse.fromJson(Map<String, dynamic> json) => GooglePlacesResponse(
        candidates: List<Candidate>.from(json["candidates"].map((x) => Candidate.fromJson(x))),
        status: googleResponseStatusValues.map[json["status"]],
      );
}

class Candidate {
  String formattedAddress;
  Geometry geometry;
  String name;

  Candidate({
    this.formattedAddress,
    this.geometry,
    this.name,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        name: json["name"],
      );
}

class Geometry {
  Location location;

  Geometry({
    this.location,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
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
