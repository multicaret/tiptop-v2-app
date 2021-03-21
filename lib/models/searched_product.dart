import 'dart:convert';

ProductsResponse productsResponseFromMap(String str) => ProductsResponse.fromMap(json.decode(str));

String productsResponseToMap(ProductsResponse data) => json.encode(data.toMap());

class ProductsResponse {
  ProductsResponse({
    this.data,
    this.errors,
    this.message,
    this.status,
  });

  List<ProductData> data;
  String errors;
  String message;
  int status;

  ProductsResponse copyWith({
    List<ProductData> data,
    String errors,
    String message,
    int status,
  }) =>
      ProductsResponse(
        data: data ?? this.data,
        errors: errors ?? this.errors,
        message: message ?? this.message,
        status: status ?? this.status,
      );

  factory ProductsResponse.fromMap(Map<String, dynamic> json) => ProductsResponse(
    data: json["data"] == null ? null : List<ProductData>.from(json["data"].map((x) => ProductData.fromMap(x))),
    errors: json["errors"] == null ? null : json["errors"],
    message: json["message"] == null ? null : json["message"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toMap() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toMap())),
    "errors": errors == null ? null : errors,
    "message": message == null ? null : message,
    "status": status == null ? null : status,
  };
}

class ProductData {
  ProductData({
    this.id,
    this.uuid,
    this.title,
    this.description,
    this.excerpt,
    this.notes,
    this.customBannerText,
    this.unitText,
    this.availableQuantity,
    this.sku,
    this.upc,
    this.minimumOrderableQuantity,
    this.avgRating,
    this.ratingCount,
    this.price,
    this.discountedPrice,
    this.barcodes,
    this.media,
    this.width,
    this.height,
    this.depth,
    this.weight,
    this.unit,
  });

  int id;
  String uuid;
  String title;
  Description description;
  Description excerpt;
  Description notes;
  dynamic customBannerText;
  dynamic unitText;
  int availableQuantity;
  String sku;
  dynamic upc;
  int minimumOrderableQuantity;
  String avgRating;
  int ratingCount;
  Price price;
  Price discountedPrice;
  List<dynamic> barcodes;
  Media media;
  double width;
  int height;
  int depth;
  double weight;
  Unit unit;

  ProductData copyWith({
    int id,
    String uuid,
    String title,
    Description description,
    Description excerpt,
    Description notes,
    dynamic customBannerText,
    dynamic unitText,
    int availableQuantity,
    String sku,
    dynamic upc,
    int minimumOrderableQuantity,
    String avgRating,
    int ratingCount,
    Price price,
    Price discountedPrice,
    List<dynamic> barcodes,
    Media media,
    double width,
    int height,
    int depth,
    double weight,
    Unit unit,
  }) =>
      ProductData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        title: title ?? this.title,
        description: description ?? this.description,
        excerpt: excerpt ?? this.excerpt,
        notes: notes ?? this.notes,
        customBannerText: customBannerText ?? this.customBannerText,
        unitText: unitText ?? this.unitText,
        availableQuantity: availableQuantity ?? this.availableQuantity,
        sku: sku ?? this.sku,
        upc: upc ?? this.upc,
        minimumOrderableQuantity: minimumOrderableQuantity ?? this.minimumOrderableQuantity,
        avgRating: avgRating ?? this.avgRating,
        ratingCount: ratingCount ?? this.ratingCount,
        price: price ?? this.price,
        discountedPrice: discountedPrice ?? this.discountedPrice,
        barcodes: barcodes ?? this.barcodes,
        media: media ?? this.media,
        width: width ?? this.width,
        height: height ?? this.height,
        depth: depth ?? this.depth,
        weight: weight ?? this.weight,
        unit: unit ?? this.unit,
      );

  factory ProductData.fromMap(Map<String, dynamic> json) => ProductData(
    id: json["id"] == null ? null : json["id"],
    uuid: json["uuid"] == null ? null : json["uuid"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : Description.fromMap(json["description"]),
    excerpt: json["excerpt"] == null ? null : Description.fromMap(json["excerpt"]),
    notes: json["notes"] == null ? null : Description.fromMap(json["notes"]),
    customBannerText: json["customBannerText"],
    unitText: json["unitText"],
    availableQuantity: json["availableQuantity"] == null ? null : json["availableQuantity"],
    sku: json["sku"] == null ? null : json["sku"],
    upc: json["upc"],
    minimumOrderableQuantity: json["minimumOrderableQuantity"] == null ? null : json["minimumOrderableQuantity"],
    avgRating: json["avgRating"] == null ? null : json["avgRating"],
    ratingCount: json["ratingCount"] == null ? null : json["ratingCount"],
    price: json["price"] == null ? null : Price.fromMap(json["price"]),
    discountedPrice: json["discountedPrice"] == null ? null : Price.fromMap(json["discountedPrice"]),
    barcodes: json["barcodes"] == null ? null : List<dynamic>.from(json["barcodes"].map((x) => x)),
    media: json["media"] == null ? null : Media.fromMap(json["media"]),
    width: json["width"] == null ? null : json["width"].toDouble(),
    height: json["height"] == null ? null : json["height"],
    depth: json["depth"] == null ? null : json["depth"],
    weight: json["weight"] == null ? null : json["weight"].toDouble(),
    unit: json["unit"] == null ? null : Unit.fromMap(json["unit"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "uuid": uuid == null ? null : uuid,
    "title": title == null ? null : title,
    "description": description == null ? null : description.toMap(),
    "excerpt": excerpt == null ? null : excerpt.toMap(),
    "notes": notes == null ? null : notes.toMap(),
    "customBannerText": customBannerText,
    "unitText": unitText,
    "availableQuantity": availableQuantity == null ? null : availableQuantity,
    "sku": sku == null ? null : sku,
    "upc": upc,
    "minimumOrderableQuantity": minimumOrderableQuantity == null ? null : minimumOrderableQuantity,
    "avgRating": avgRating == null ? null : avgRating,
    "ratingCount": ratingCount == null ? null : ratingCount,
    "price": price == null ? null : price.toMap(),
    "discountedPrice": discountedPrice == null ? null : discountedPrice.toMap(),
    "barcodes": barcodes == null ? null : List<dynamic>.from(barcodes.map((x) => x)),
    "media": media == null ? null : media.toMap(),
    "width": width == null ? null : width,
    "height": height == null ? null : height,
    "depth": depth == null ? null : depth,
    "weight": weight == null ? null : weight,
    "unit": unit == null ? null : unit.toMap(),
  };
}

class Description {
  Description({
    this.raw,
    this.formatted,
  });

  String raw;
  String formatted;

  Description copyWith({
    String raw,
    String formatted,
  }) =>
      Description(
        raw: raw ?? this.raw,
        formatted: formatted ?? this.formatted,
      );

  factory Description.fromMap(Map<String, dynamic> json) => Description(
    raw: json["raw"] == null ? null : json["raw"],
    formatted: json["formatted"] == null ? null : json["formatted"],
  );

  Map<String, dynamic> toMap() => {
    "raw": raw == null ? null : raw,
    "formatted": formatted == null ? null : formatted,
  };
}

class Price {
  Price({
    this.amount,
    this.amountFormatted,
  });

  int amount;
  String amountFormatted;

  Price copyWith({
    int amount,
    String amountFormatted,
  }) =>
      Price(
        amount: amount ?? this.amount,
        amountFormatted: amountFormatted ?? this.amountFormatted,
      );

  factory Price.fromMap(Map<String, dynamic> json) => Price(
    amount: json["amount"] == null ? null : json["amount"],
    amountFormatted: json["amountFormatted"] == null ? null : json["amountFormatted"],
  );

  Map<String, dynamic> toMap() => {
    "amount": amount == null ? null : amount,
    "amountFormatted": amountFormatted == null ? null : amountFormatted,
  };
}

class Media {
  Media({
    this.cover,
    this.gallery,
  });

  String cover;
  List<dynamic> gallery;

  Media copyWith({
    String cover,
    List<dynamic> gallery,
  }) =>
      Media(
        cover: cover ?? this.cover,
        gallery: gallery ?? this.gallery,
      );

  factory Media.fromMap(Map<String, dynamic> json) => Media(
    cover: json["cover"] == null ? null : json["cover"],
    gallery: json["gallery"] == null ? null : List<dynamic>.from(json["gallery"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "cover": cover == null ? null : cover,
    "gallery": gallery == null ? null : List<dynamic>.from(gallery.map((x) => x)),
  };
}

class Unit {
  Unit({
    this.id,
    this.title,
    this.step,
  });

  int id;
  String title;
  String step;

  Unit copyWith({
    int id,
    String title,
    String step,
  }) =>
      Unit(
        id: id ?? this.id,
        title: title ?? this.title,
        step: step ?? this.step,
      );

  factory Unit.fromMap(Map<String, dynamic> json) => Unit(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    step: json["step"] == null ? null : json["step"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "step": step == null ? null : step,
  };
}
