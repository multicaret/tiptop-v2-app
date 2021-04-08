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
    this.categories,
    this.restaurants,
  });

  List<Slide> slides;
  Cart cart;
  EstimatedArrivalTime estimatedArrivalTime;
  List<Order> activeOrders;
  int totalActiveOrders;
  Branch branch;
  double distance;
  List<Category> categories;
  List<Branch> restaurants;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        slides: List<Slide>.from(json["slides"].map((x) => Slide.fromJson(x))),
        cart: json["cart"] == null ? null : Cart.fromJson(json["cart"]),
        estimatedArrivalTime: EstimatedArrivalTime.fromJson(json["estimated_arrival_time"]),
        activeOrders: json["activeOrders"] == null ? null : List<Order>.from(json["activeOrders"].map((x) => Order.fromJson(x))),
        totalActiveOrders: json["totalActiveOrders"],
        branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
        distance: json["distance"] == null ? 0.0 : json["distance"].toDouble(),
        categories: json["categories"] == null ? <Category>[] : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        restaurants: json["restaurants"] == null ? <Branch>[] : List<Branch>.from(json["restaurants"].map((x) => Branch.fromJson(x))),
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
    this.title,
    this.regionId,
    this.cityId,
    this.tiptopDelivery,
    this.restaurantDelivery,
    this.primaryPhoneNumber,
    this.secondaryPhoneNumber,
    this.whatsappPhoneNumber,
    this.rating,
    this.workingHours,
    this.latitude,
    this.longitude,
    this.chain,
  });

  int id;
  String title;
  int regionId;
  int cityId;
  BranchDelivery tiptopDelivery;
  BranchDelivery restaurantDelivery;
  String primaryPhoneNumber;
  String secondaryPhoneNumber;
  String whatsappPhoneNumber;
  BranchRating rating;
  WorkingHours workingHours;
  double latitude;
  double longitude;
  Chain chain;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        title: json["title"],
        regionId: json["regionId"],
        cityId: json["cityId"],
        tiptopDelivery: BranchDelivery.fromJson(json["tiptopDelivery"]),
        restaurantDelivery: BranchDelivery.fromJson(json["restaurantDelivery"]),
        primaryPhoneNumber: json["primaryPhoneNumber"],
        secondaryPhoneNumber: json["secondaryPhoneNumber"],
        whatsappPhoneNumber: json["whatsappPhoneNumber"],
        rating: BranchRating.fromJson(json["rating"]),
        workingHours: WorkingHours.fromJson(json["workingHours"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
        chain: json["chain"] == null ? null : Chain.fromJson(json["chain"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "regionId": regionId,
        "cityId": cityId,
        "tiptopDelivery": tiptopDelivery.toJson(),
        "restaurantDelivery": restaurantDelivery.toJson(),
        "primaryPhoneNumber": primaryPhoneNumber,
        "secondaryPhoneNumber": secondaryPhoneNumber,
        "whatsappPhoneNumber": whatsappPhoneNumber,
        "latitude": latitude,
        "longitude": longitude,
        "chain": chain == null ? null : chain.toJson(),
      };
}

class BranchDelivery {
  BranchDelivery({
    this.isDeliveryEnabled,
    this.minimumOrder,
    this.underMinimumOrderDeliveryFee,
    this.fixedDeliveryFee,
    this.freeDeliveryThreshold,
    this.minDeliveryMinutes,
    this.maxDeliveryMinutes,
  });

  bool isDeliveryEnabled;
  DoubleRawIntFormatted minimumOrder;
  DoubleRawIntFormatted underMinimumOrderDeliveryFee;
  DoubleRawIntFormatted fixedDeliveryFee;
  DoubleRawIntFormatted freeDeliveryThreshold;
  int minDeliveryMinutes;
  int maxDeliveryMinutes;

  factory BranchDelivery.fromJson(Map<String, dynamic> json) => BranchDelivery(
        isDeliveryEnabled: json["isDeliveryEnabled"],
        minimumOrder: DoubleRawIntFormatted.fromJson(json["minimumOrder"]),
        underMinimumOrderDeliveryFee: DoubleRawIntFormatted.fromJson(json["underMinimumOrderDeliveryFee"]),
        fixedDeliveryFee: DoubleRawIntFormatted.fromJson(json["fixedDeliveryFee"]),
        freeDeliveryThreshold: DoubleRawIntFormatted.fromJson(json["freeDeliveryThreshold"]),
        minDeliveryMinutes: json["minDeliveryMinutes"],
        maxDeliveryMinutes: json["maxDeliveryMinutes"],
      );

  Map<String, dynamic> toJson() => {
        "isDeliveryEnabled": isDeliveryEnabled,
        "minimumOrder": minimumOrder.toJson(),
        "underMinimumOrderDeliveryFee": underMinimumOrderDeliveryFee.toJson(),
        "fixedDeliveryFee": fixedDeliveryFee.toJson(),
        "freeDeliveryThreshold": freeDeliveryThreshold.toJson(),
        "minDeliveryMinutes": minDeliveryMinutes,
        "maxDeliveryMinutes": maxDeliveryMinutes,
      };
}

class BranchRating {
  BranchRating({
    this.colorHexadecimal,
    this.colorRGBA,
    this.averageRaw,
    this.averageFormatted,
    this.countRaw,
    this.countFormatted,
  });

  String colorHexadecimal;
  String colorRGBA;
  double averageRaw;
  String averageFormatted;
  int countRaw;
  String countFormatted;

  factory BranchRating.fromJson(Map<String, dynamic> json) => BranchRating(
        colorHexadecimal: json["colorHexadecimal"],
        colorRGBA: json["colorRGBA"],
        averageRaw: json["averageRaw"].toDouble(),
        averageFormatted: json["averageFormatted"],
        countRaw: json["countRaw"],
        countFormatted: json["countFormatted"],
      );
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
