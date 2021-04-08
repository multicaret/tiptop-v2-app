import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/product.dart';

class Category {
  Category({
    this.id,
    this.icon,
    this.englishTitle,
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
  String englishTitle;
  String title;
  StringRawStringFormatted description;
  bool hasChildren;
  String cover;
  String thumbnail;
  List<Category> childCategories;
  List<Product> products;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        icon: json["icon"],
        englishTitle: json["englishTitle"],
        title: json["title"],
        description: StringRawStringFormatted.fromJson(json["description"]),
        hasChildren: json["hasChildren"],
        cover: json["cover"],
        thumbnail: json["thumbnail"],
        childCategories: json["children"] == null ? <Category>[] : List<Category>.from(json["children"].map((x) => Category.fromJson(x))),
        products: json["products"] == null ? <Product>[] : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "englishTitle": englishTitle,
        "title": title,
        "description": description.toJson(),
        "hasChildren": hasChildren == null ? null : hasChildren,
        "children": childCategories == null ? null : List<dynamic>.from(childCategories.map((x) => x.toJson())),
        "cover": cover,
        "thumbnail": thumbnail,
        "products": products == null ? null : List<dynamic>.from(products.map((x) => x.toJson())),
      };
}
