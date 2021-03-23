import 'dart:convert';

import 'category.dart';
import 'models.dart';

ProductsDataResponse productDataResponseFromJson(String str) => ProductsDataResponse.fromJson(json.decode(str));

class ProductsDataResponse {
  ProductsDataResponse({
    this.parentsData,
    this.errors,
    this.message,
    this.status,
  });

  ParentsData parentsData;
  String errors;
  String message;
  int status;

  factory ProductsDataResponse.fromJson(Map<String, dynamic> json) => ProductsDataResponse(
        parentsData: json["data"] == null ? null : ParentsData.fromJson(json["data"]),
        errors: json["errors"],
        message: json["message"],
        status: json["status"],
      );
}

class ParentsData {
  ParentsData({
    this.selectedParent,
    this.parents,
  });

  Category selectedParent;
  List<Category> parents;

  factory ParentsData.fromJson(Map<String, dynamic> json) => ParentsData(
        selectedParent: Category.fromJson(json["selectedParent"]),
        parents: List<Category>.from(json["parents"].map((x) => Category.fromJson(x))),
      );
}

Product productFromJson(String str) => Product.fromJson(json.decode(str));

class Product {
  Product({
    this.id,
    this.uuid,
    this.title,
    this.description,
    this.excerpt,
    this.notes,
    this.customBannerText,
    this.availableQuantity,
    this.unitText,
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
  StringRawStringFormatted description;
  StringRawStringFormatted excerpt;
  StringRawStringFormatted notes;
  dynamic customBannerText;
  int availableQuantity;
  String unitText;
  String sku;
  dynamic upc;
  int minimumOrderableQuantity;
  String avgRating;
  int ratingCount;
  DoubleRawIntFormatted price;
  DoubleRawIntFormatted discountedPrice;
  List<dynamic> barcodes;
  Media media;
  double width;
  int height;
  int depth;
  double weight;
  Unit unit;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        uuid: json["uuid"],
        title: json["title"],
        description: json["description"] == null ? null : StringRawStringFormatted.fromJson(json["description"]),
        excerpt: json["excerpt"] == null ? null : StringRawStringFormatted.fromJson(json["excerpt"]),
        notes: json["notes"]  == null ? null : StringRawStringFormatted.fromJson(json["notes"]),
        customBannerText: json["customBannerText"],
        availableQuantity: json["availableQuantity"],
        unitText: json["unitText"],
        sku: json["sku"],
        upc: json["upc"],
        minimumOrderableQuantity: json["minimumOrderableQuantity"],
        avgRating: json["avgRating"],
        ratingCount: json["ratingCount"],
        price: DoubleRawIntFormatted.fromJson(json["price"]),
        discountedPrice: json["discountedPrice"] == null ? null : DoubleRawIntFormatted.fromJson(json["discountedPrice"]),
        barcodes: json["barcodes"] == null ? null : List<dynamic>.from(json["barcodes"].map((x) => x)),
        media: Media.fromJson(json["media"]),
        width: json["width"].toDouble(),
        height: json["height"],
        depth: json["depth"],
        weight: json["weight"].toDouble(),
        unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "title": title,
        "description": description,
        "excerpt": excerpt,
        "notes": notes,
        "customBannerText": customBannerText,
        "availableQuantity": availableQuantity,
        "unitText": unitText,
        "sku": sku,
        "upc": upc,
        "minimumOrderableQuantity": minimumOrderableQuantity,
        "avgRating": avgRating,
        "ratingCount": ratingCount,
        "price": price.toJson(),
        "discountedPrice": discountedPrice == null ? null : discountedPrice.toJson(),
        "barcodes": List<dynamic>.from(barcodes.map((x) => x)),
        "media": media.toJson(),
        "width": width,
        "height": height,
        "depth": depth,
        "weight": weight,
        "unit": unit.toJson(),
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

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        title: json["title"],
        step: json["step"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "step": step,
      };
}
