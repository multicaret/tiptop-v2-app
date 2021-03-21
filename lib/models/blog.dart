import 'dart:convert';

import 'package:tiptop_v2/models/models.dart';

BlogResponse blogResponseFromJson(String str) => BlogResponse.fromJson(json.decode(str));

String blogResponseToJson(BlogResponse data) => json.encode(data.toJson());

class BlogResponse {
  BlogResponse({
    this.articles,
  });

  List<Article> articles;

  factory BlogResponse.fromJson(Map<String, dynamic> json) => BlogResponse(
        articles: List<Article>.from(json["data"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class Article {
  Article({
    this.id,
    this.title,
    this.content,
    this.exc,
    this.notes,
    this.views,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  StringRawStringFormatted content;
  StringRawStringFormatted exc;
  StringRawStringFormatted notes;
  IntRawStringFormatted views;
  EdAt createdAt;
  EdAt updatedAt;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        content: StringRawStringFormatted.fromJson(json["content"]),
        exc: StringRawStringFormatted.fromJson(json["excerpt"]),
        notes: StringRawStringFormatted.fromJson(json["notes"]),
        views: IntRawStringFormatted.fromJson(json["views"]),
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
        "createdAt": createdAt.toJson(),
        "updatedAt": updatedAt.toJson(),
      };
}
