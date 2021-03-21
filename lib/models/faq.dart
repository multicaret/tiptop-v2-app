import 'dart:convert';
import 'models.dart';

FaqResponse faqResponseFromJson(String str) => FaqResponse.fromJson(json.decode(str));

String faqResponseToJson(FaqResponse data) => json.encode(data.toJson());

class FaqResponse {
  FaqResponse({
    this.data,
  });

  List<FaqItem> data;

  factory FaqResponse.fromJson(Map<String, dynamic> json) => FaqResponse(
        data: List<FaqItem>.from(json["data"].map((x) => FaqItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FaqItem {
  FaqItem({
    this.id,
    this.question,
    this.answer,
  });

  int id;
  String question;
  StringRawStringFormatted answer;

  factory FaqItem.fromJson(Map<String, dynamic> json) => FaqItem(
        id: json["id"],
        question: json["question"],
        answer: StringRawStringFormatted.fromJson(json["answer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer.toJson(),
      };
}
