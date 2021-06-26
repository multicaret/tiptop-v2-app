import 'package:tiptop_v2/models/models.dart';

class Article {
  Article({
    this.id,
    this.title,
    this.content,
    this.exc,
    this.notes,
    this.views,
    this.cover,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  StringRawStringFormatted content;
  StringRawStringFormatted exc;
  StringRawStringFormatted notes;
  IntRawStringFormatted views;
  String cover;
  EdAt createdAt;
  EdAt updatedAt;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        content: StringRawStringFormatted.fromJson(json["content"]),
        exc: StringRawStringFormatted.fromJson(json["excerpt"]),
        notes: StringRawStringFormatted.fromJson(json["notes"]),
        views: IntRawStringFormatted.fromJson(json["views"]),
        cover: json["cover"],
        createdAt: EdAt.fromJson(json["createdAt"]),
        updatedAt: EdAt.fromJson(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content.toJson(),
        "excerpt": exc.toJson(),
        "notes": notes.toJson(),
        "views": views.toJson(),
        "cover": cover,
        "createdAt": createdAt.toJson(),
        "updatedAt": updatedAt.toJson(),
      };
}
