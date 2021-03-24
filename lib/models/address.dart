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

class City {
  City({
    this.id,
    this.name,
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
  Name name;
  dynamic description;
  dynamic code;
  Country country;
  Region region;
  Timezone timezone;
  dynamic population;
  double latitude;
  double longitude;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: Name.fromJson(json["name"]),
    description: json["description"],
    code: json["code"],
    country: Country.fromJson(json["country"]),
    region: Region.fromJson(json["region"]),
    timezone: Timezone.fromJson(json["timezone"]),
    population: json["population"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name.toJson(),
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
    this.nameEnglish,
    this.name,
    this.alpha2Code,
    this.alpha3Code,
    this.numericCode,
    this.phoneCode,
    this.flagUrl,
    this.currency,
    this.timezone,
  });

  int id;
  String nameEnglish;
  String name;
  String alpha2Code;
  String alpha3Code;
  int numericCode;
  String phoneCode;
  String flagUrl;
  Currency currency;
  Timezone timezone;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    nameEnglish: json["nameEnglish"],
    name: json["name"],
    alpha2Code: json["alpha2Code"],
    alpha3Code: json["alpha3Code"],
    numericCode: json["numericCode"],
    phoneCode: json["phoneCode"],
    flagUrl: json["flagUrl"],
    currency: Currency.fromJson(json["currency"]),
    timezone: Timezone.fromJson(json["timezone"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nameEnglish": nameEnglish,
    "name": name,
    "alpha2Code": alpha2Code,
    "alpha3Code": alpha3Code,
    "numericCode": numericCode,
    "phoneCode": phoneCode,
    "flagUrl": flagUrl,
    "currency": currency.toJson(),
    "timezone": timezone.toJson(),
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

class Name {
  Name({
    this.original,
    this.translated,
  });

  String original;
  String translated;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
    original: json["original"],
    translated: json["translated"],
  );

  Map<String, dynamic> toJson() => {
    "original": original,
    "translated": translated,
  };
}

class Region {
  Region({
    this.id,
    this.nameEnglish,
    this.name,
    this.code,
  });

  int id;
  String nameEnglish;
  String name;
  String code;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    id: json["id"],
    nameEnglish: json["nameEnglish"],
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nameEnglish": nameEnglish,
    "name": name,
    "code": code,
  };
}
