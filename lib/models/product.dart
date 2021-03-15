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
    this.unitText,
    this.quantity,
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
  });

  int id;
  String uuid;
  String title;
  StringRawStringFormatted description;
  dynamic excerpt;
  dynamic notes;
  dynamic customBannerText;
  dynamic unitText;
  int quantity;
  String sku;
  dynamic upc;
  int minimumOrderableQuantity;
  String avgRating;
  int ratingCount;
  IntRawStringFormatted price;
  IntRawStringFormatted discountedPrice;
  List<dynamic> barcodes;
  Media media;
  double width;
  int height;
  int depth;
  double weight;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        uuid: json["uuid"],
        title: json["title"],
        description: json["description"],
        excerpt: json["excerpt"],
        notes: json["notes"],
        customBannerText: json["customBannerText"],
        unitText: json["unitText"],
        quantity: json["quantity"],
        sku: json["sku"],
        upc: json["upc"],
        minimumOrderableQuantity: json["minimumOrderableQuantity"],
        avgRating: json["avgRating"],
        ratingCount: json["ratingCount"],
        price: IntRawStringFormatted.fromJson(json["price"]),
        discountedPrice: IntRawStringFormatted.fromJson(json["discountedPrice"]),
        barcodes: List<dynamic>.from(json["barcodes"].map((x) => x)),
        media: Media.fromJson(json["media"]),
        width: json["width"].toDouble(),
        height: json["height"],
        depth: json["depth"],
        weight: json["weight"].toDouble(),
      );
}