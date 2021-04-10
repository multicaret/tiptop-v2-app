import 'package:tiptop_v2/models/models.dart';

import 'cart.dart';
import 'category.dart';
import 'order.dart';

class HomeData {
  HomeData({
    this.slides,
    this.cart,
    this.estimatedArrivalTime,
    this.activeOrders,
    this.totalActiveOrders,
    this.branch,
    this.distance,
    this.hasAvailableBranchesNow,
    this.categories,
  });

  List<Slide> slides;
  Cart cart;
  EstimatedArrivalTime estimatedArrivalTime;
  List<Order> activeOrders;
  int totalActiveOrders;
  Branch branch;
  dynamic distance;
  bool hasAvailableBranchesNow;
  List<Category> categories;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        slides: List<Slide>.from(json["slides"].map((x) => Slide.fromJson(x))),
        cart: json["cart"] == null ? null : Cart.fromJson(json["cart"]),
        estimatedArrivalTime: EstimatedArrivalTime.fromJson(json["estimated_arrival_time"]),
        activeOrders: json["activeOrders"] == null ? null : List<Order>.from(json["activeOrders"].map((x) => Order.fromJson(x))),
        totalActiveOrders: json["totalActiveOrders"],
        branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
        distance: json["distance"],
        hasAvailableBranchesNow: json["hasAvailableBranchesNow"],
        categories: json["categories"] == null ? <Category>[] : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
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

class Branch {
  Branch({
    this.id,
    this.regionId,
    this.cityId,
    this.minimumOrder,
    this.underMinimumOrderDeliveryFee,
    this.fixedDeliveryFee,
    this.primaryPhoneNumber,
    this.secondaryPhoneNumber,
    this.whatsappPhoneNumber,
    this.latitude,
    this.longitude,
    this.chain,
  });

  int id;
  int regionId;
  int cityId;
  IntRawStringFormatted minimumOrder;
  IntRawStringFormatted underMinimumOrderDeliveryFee;
  IntRawStringFormatted fixedDeliveryFee;
  String primaryPhoneNumber;
  String secondaryPhoneNumber;
  String whatsappPhoneNumber;
  double latitude;
  double longitude;
  Chain chain;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        regionId: json["regionId"],
        cityId: json["cityId"],
        minimumOrder: IntRawStringFormatted.fromJson(json["minimumOrder"]),
        underMinimumOrderDeliveryFee: IntRawStringFormatted.fromJson(json["underMinimumOrderDeliveryFee"]),
        fixedDeliveryFee: IntRawStringFormatted.fromJson(json["fixedDeliveryFee"]),
        primaryPhoneNumber: json["primaryPhoneNumber"],
        secondaryPhoneNumber: json["secondaryPhoneNumber"],
        whatsappPhoneNumber: json["whatsappPhoneNumber"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        chain: json["chain"] == null ? null : Chain.fromJson(json["chain"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "regionId": regionId,
        "cityId": cityId,
        "minimumOrder": minimumOrder.toJson(),
        "underMinimumOrderDeliveryFee": underMinimumOrderDeliveryFee.toJson(),
        "fixedDeliveryFee": fixedDeliveryFee.toJson(),
        "primaryPhoneNumber": primaryPhoneNumber,
        "secondaryPhoneNumber": secondaryPhoneNumber,
        "whatsappPhoneNumber": whatsappPhoneNumber,
        "latitude": latitude,
        "longitude": longitude,
        "chain": chain == null ? null : chain.toJson(),
      };
}

class Chain {
  Chain({
    this.id,
    this.regionId,
    this.cityId,
    this.currencyId,
    this.primaryPhoneNumber,
    this.secondaryPhoneNumber,
    this.whatsappPhoneNumber,
    this.primaryColor,
    this.secondaryColor,
    this.numberOfItemsOnMobileGridView,
    this.media,
  });

  int id;
  int regionId;
  int cityId;
  int currencyId;
  String primaryPhoneNumber;
  String secondaryPhoneNumber;
  String whatsappPhoneNumber;
  String primaryColor;
  String secondaryColor;
  int numberOfItemsOnMobileGridView;
  Media media;

  factory Chain.fromJson(Map<String, dynamic> json) => Chain(
        id: json["id"],
        regionId: json["regionId"],
        cityId: json["cityId"],
        currencyId: json["currencyId"],
        primaryPhoneNumber: json["primaryPhoneNumber"],
        secondaryPhoneNumber: json["secondaryPhoneNumber"],
        whatsappPhoneNumber: json["whatsappPhoneNumber"],
        primaryColor: json["primaryColor"],
        secondaryColor: json["secondaryColor"],
        numberOfItemsOnMobileGridView: json["numberOfItemsOnMobileGridView"],
        media: Media.fromJson(json["media"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "regionId": regionId,
        "cityId": cityId,
        "currencyId": currencyId,
        "primaryPhoneNumber": primaryPhoneNumber,
        "secondaryPhoneNumber": secondaryPhoneNumber,
        "whatsappPhoneNumber": whatsappPhoneNumber,
        "primaryColor": primaryColor,
        "secondaryColor": secondaryColor,
        "numberOfItemsOnMobileGridView": numberOfItemsOnMobileGridView,
        "media": media.toJson(),
      };
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
  int linkType;
  String image;

  factory Slide.fromJson(Map<String, dynamic> json) => Slide(
        title: json["title"],
        description: StringRawStringFormatted.fromJson(json["description"]),
        linkValue: json["linkValue"],
        linkType: json["linkType"],
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
