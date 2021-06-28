import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/branch.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/order.dart';

class HomeData {
  HomeData({
    this.slides,
    this.cart,
    this.estimatedArrivalTime,
    this.activeOrders,
    this.totalActiveOrders,
    this.noAvailabilityMessage,
    this.branch,
    this.distance,
    this.categories,
    this.restaurants,
    this.currentCurrency,
  });

  List<Slide> slides;
  Cart cart;
  EstimatedArrivalTime estimatedArrivalTime;
  List<Order> activeOrders;
  int totalActiveOrders;
  String noAvailabilityMessage;
  Branch branch;
  double distance;
  List<Category> categories;
  List<Branch> restaurants;
  Currency currentCurrency;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        slides: List<Slide>.from(json["slides"].map((x) => Slide.fromJson(x))),
        cart: json["cart"] == null ? null : Cart.fromJson(json["cart"]),
        estimatedArrivalTime: EstimatedArrivalTime.fromJson(json["estimated_arrival_time"]),
        activeOrders: json["activeOrders"] == null ? <Order>[] : List<Order>.from(json["activeOrders"].map((x) => Order.fromJson(x))),
        totalActiveOrders: json["totalActiveOrders"],
        noAvailabilityMessage: json["noAvailabilityMessage"],
        branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
        distance: json["distance"] == null ? 0.0 : json["distance"].toDouble(),
        categories: json["categories"] == null ? <Category>[] : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        restaurants: json["restaurants"] == null ? <Branch>[] : List<Branch>.from(json["restaurants"].map((x) => Branch.fromJson(x))),
        currentCurrency: Currency.fromJson(json["currentCurrency"]),
      );
}

class EstimatedArrivalTime {
  EstimatedArrivalTime({
    this.value,
    this.unit,
  });

  String value;
  String unit;

  factory EstimatedArrivalTime.fromJson(Map<String, dynamic> json) => EstimatedArrivalTime(
        value: json["value"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "unit": unit,
      };
}

class WorkingHours {
  List<String> offs;
  String offsRendered;
  String opensAt;
  String closesAt;
  bool isOpen;
  List<Schedule> schedule;

  WorkingHours({
    this.offs,
    this.offsRendered,
    this.opensAt,
    this.closesAt,
    this.isOpen,
    this.schedule,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) => WorkingHours(
        offs: List<String>.from(json["offs"].map((x) => x)),
        offsRendered: json["offsRendered"],
        opensAt: json["opensAt"],
        closesAt: json["closesAt"],
        isOpen: json["isOpen"],
        schedule: List<Schedule>.from(json["schedule"].map((x) => Schedule.fromJson(x))),
      );
}

class Schedule {
  int id;
  String day;
  String opensAt;
  String closesAt;

  Schedule({
    this.id,
    this.day,
    this.opensAt,
    this.closesAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        day: json["day"],
        opensAt: json["opensAt"],
        closesAt: json["closesAt"],
      );
}

class Slide {
  Slide({
    this.title,
    this.description,
    this.linkValue,
    this.linkType,
    this.image,
  });

  String title;
  StringRawStringFormatted description;
  String linkValue;
  LinkType linkType;
  String image;

  factory Slide.fromJson(Map<String, dynamic> json) => Slide(
        title: json["title"],
        description: StringRawStringFormatted.fromJson(json["description"]),
        linkValue: json["linkValue"],
        linkType: json["linkType"] == null ? null : linkTypeValues.map[json["linkType"].toString()],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description.toJson(),
        "linkValue": linkValue,
        "linkType": linkType,
        "image": image,
      };
}
