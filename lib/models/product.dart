import 'dart:convert';

import 'category.dart';
import 'models.dart';

class CategoryParentsData {
  CategoryParentsData({
    this.selectedParentCategory,
    this.parentCategories,
  });

  Category selectedParentCategory;
  List<Category> parentCategories;

  factory CategoryParentsData.fromJson(Map<String, dynamic> json) => CategoryParentsData(
        selectedParentCategory: Category.fromJson(json["selectedParent"]),
        parentCategories: List<Category>.from(json["parents"].map((x) => Category.fromJson(x))),
      );
}

Product productFromJson(String str) => Product.fromJson(json.decode(str));

class Product {
  Product({
    this.id,
    this.uuid,
    this.englishTitle,
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
    this.isFavorited,
    this.unit,
  });

  int id;
  String uuid;
  String englishTitle;
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
  double height;
  double depth;
  double weight;
  bool isFavorited;
  Unit unit;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        uuid: json["uuid"],
        englishTitle: json["englishTitle"],
        title: json["title"],
        description: json["description"] == null ? null : StringRawStringFormatted.fromJson(json["description"]),
        excerpt: json["excerpt"] == null ? null : StringRawStringFormatted.fromJson(json["excerpt"]),
        notes: json["notes"] == null ? null : StringRawStringFormatted.fromJson(json["notes"]),
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
        width: json["width"] == null ? null : json["width"].toDouble(),
        height: json["height"] == null ? null : json["height"].toDouble(),
        depth: json["depth"] == null ? null : json["depth"].toDouble(),
        weight: json["weight"] == null ? null : json["weight"].toDouble(),
        isFavorited: json["isFavorited"],
        unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "englishTitle": englishTitle,
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
        "isFavorited": isFavorited,
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
