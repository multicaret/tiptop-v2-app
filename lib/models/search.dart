import 'dart:convert';

import 'package:tiptop_v2/models/models.dart';

SearchResponse searchResponseFromJson(String str) => SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse({
    this.search,
    this.errors,
    this.message,
    this.status,
  });

  Search search;
  String errors;
  String message;
  int status;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        search: Search.fromJson(json["data"]),
        errors: json["errors"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": search.toJson(),
        "errors": errors,
        "message": message,
        "status": status,
      };
}

class Search {
  Search({
    this.terms,
  });

  List<Term> terms;

  factory Search.fromJson(Map<String, dynamic> json) => Search(
        terms: List<Term>.from(json["terms"].map((x) => Term.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "terms": List<dynamic>.from(terms.map((x) => x.toJson())),
      };
}

class Term {
  Term({
    this.id,
    this.term,
    this.count,
    this.locale,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String term;
  IntRawStringFormatted count;
  String locale;
  EdAt createdAt;
  EdAt updatedAt;

  factory Term.fromJson(Map<String, dynamic> json) => Term(
        id: json["id"],
        term: json["term"],
        count: IntRawStringFormatted.fromJson(json["count"]),
        locale: json["locale"],
        createdAt: EdAt.fromJson(json["createdAt"]),
        updatedAt: EdAt.fromJson(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "term": term,
        "count": count.toJson(),
        "locale": locale,
        "createdAt": createdAt.toJson(),
        "updatedAt": updatedAt.toJson(),
      };
}
