// To parse this JSON data, do
//
//     final staticPageResponse = staticPageResponseFromJson(jsonString);

import 'dart:convert';

import 'models.dart';

StaticPageResponse staticPageResponseFromJson(String str) => StaticPageResponse.fromJson(json.decode(str));

String staticPageResponseToJson(StaticPageResponse data) => json.encode(data.toJson());

class StaticPageResponse {
  StaticPageResponse({
    this.staticPage,
  });

  StaticPage staticPage;

  factory StaticPageResponse.fromJson(Map<String, dynamic> json) => StaticPageResponse(
        staticPage: StaticPage.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": staticPage.toJson(),
      };
}

class StaticPage {
  StaticPage({
    this.id,
    this.title,
    this.content,
    this.views,
  });

  int id;
  String title;
  StringRawStringFormatted content;
  IntRawStringFormatted views;

  factory StaticPage.fromJson(Map<String, dynamic> json) => StaticPage(
        id: json["id"],
        title: json["title"],
        content: StringRawStringFormatted.fromJson(json["content"]),
        views: IntRawStringFormatted.fromJson(json["views"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content.toJson(),
        "views": views.toJson(),
      };
}
