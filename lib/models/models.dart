import 'dart:convert';

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

enum GoogleResponseStatus {
  OK,
  ZERO_RESULTS,
  OVER_QUERY_LIMIT,
  REQUEST_DENIED,
  INVALID_REQUEST,
  UNKNOWN_ERROR,
}

final googleResponseStatusValues = EnumValues({
  "OK": GoogleResponseStatus.OK,
  "ZERO_RESULTS": GoogleResponseStatus.ZERO_RESULTS,
  "OVER_QUERY_LIMIT": GoogleResponseStatus.OVER_QUERY_LIMIT,
  "REQUEST_DENIED": GoogleResponseStatus.REQUEST_DENIED,
  "INVALID_REQUEST": GoogleResponseStatus.INVALID_REQUEST,
  "UNKNOWN_ERROR": GoogleResponseStatus.UNKNOWN_ERROR,
});

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


