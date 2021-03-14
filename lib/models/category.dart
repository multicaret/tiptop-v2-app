import 'package:tiptop_v2/models/models.dart';

class Category {
  Category({
    this.id,
    this.icon,
    this.title,
    this.description,
    this.hasChildren,
    this.cover,
    this.thumbnail,
  });

  int id;
  dynamic icon;
  String title;
  StringRawStringFormatted description;
  bool hasChildren;
  String cover;
  dynamic thumbnail;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    icon: json["icon"],
    title: json["title"],
    description: StringRawStringFormatted.fromJson(json["description"]),
    hasChildren: json["hasChildren"],
    cover: json["cover"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "icon": icon,
    "title": title,
    "description": description.toJson(),
    "hasChildren": hasChildren,
    "cover": cover,
    "thumbnail": thumbnail,
  };
}