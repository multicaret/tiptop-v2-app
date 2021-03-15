import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/product.dart';

class Category {
  Category({
    this.id,
    this.icon,
    this.title,
    this.description,
    this.hasChildren,
    this.cover,
    this.thumbnail,
    this.childCategories,
    this.products,
  });

  int id;
  dynamic icon;
  String title;
  StringRawStringFormatted description;
  bool hasChildren;
  String cover;
  dynamic thumbnail;
  List<Category> childCategories;
  List<Product> products;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    icon: json["icon"],
    title: json["title"],
    description: StringRawStringFormatted.fromJson(json["description"]),
    hasChildren: json["hasChildren"],
    cover: json["cover"],
    thumbnail: json["thumbnail"],
    childCategories: json["children"] == null ? null : List<Category>.from(json["children"].map((x) => Category.fromJson(x))),
    products: json["products"] == null ? null : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );
}