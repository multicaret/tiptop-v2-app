import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/product.dart';

class PaginatedRestaurantsResponse {
  PaginatedRestaurantsResponse({
    this.restaurants,
    this.pagination,
  });

  List<Branch> restaurants;
  Pagination pagination;

  factory PaginatedRestaurantsResponse.fromJson(Map<String, dynamic> json) => PaginatedRestaurantsResponse(
        restaurants: List<Branch>.from(json["restaurants"].map((x) => Branch.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );
}

class Branch {
  Branch({
    this.id,
    this.title,
    this.englishTitle,
    this.regionEnglishName,
    this.regionId,
    this.cityId,
    this.tiptopDelivery,
    this.restaurantDelivery,
    this.primaryPhoneNumber,
    this.secondaryPhoneNumber,
    this.whatsappPhoneNumber,
    this.rating,
    this.distanceToCurrentAddress,
    this.workingHours,
    this.latitude,
    this.longitude,
    this.chain,
    this.isFavorited,
    this.categories,
    this.searchProducts,
  });

  int id;
  String title;
  String englishTitle;
  String regionEnglishName;
  int regionId;
  int cityId;
  BranchDelivery tiptopDelivery;
  BranchDelivery restaurantDelivery;
  String primaryPhoneNumber;
  String secondaryPhoneNumber;
  String whatsappPhoneNumber;
  BranchRating rating;
  double distanceToCurrentAddress;
  WorkingHours workingHours;
  double latitude;
  double longitude;
  Chain chain;
  bool isFavorited;
  List<Category> categories;
  List<Product> searchProducts;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        title: json["title"],
        englishTitle: json["englishTitle"],
        regionEnglishName: json["regionEnglishName"],
        regionId: json["regionId"],
        cityId: json["cityId"],
        tiptopDelivery: BranchDelivery.fromJson(json["tiptopDelivery"]),
        restaurantDelivery: BranchDelivery.fromJson(json["restaurantDelivery"]),
        primaryPhoneNumber: json["primaryPhoneNumber"],
        secondaryPhoneNumber: json["secondaryPhoneNumber"],
        whatsappPhoneNumber: json["whatsappPhoneNumber"],
        rating: BranchRating.fromJson(json["rating"]),
        distanceToCurrentAddress: json["distanceToCurrentAddress"] == null ? null : json["distanceToCurrentAddress"].toDouble(),
        workingHours: WorkingHours.fromJson(json["workingHours"]),
        latitude: json["latitude"] == null ? 0.0 : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? 0.0 : json["longitude"].toDouble(),
        isFavorited: json["isFavorited"],
        chain: json["chain"] == null ? null : Chain.fromJson(json["chain"]),
        categories: json["categories"] == null ? <Category>[] : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        searchProducts: json["searchProducts"] == null ? <Product>[] : List<Product>.from(json["searchProducts"].map((x) => Product.fromJson(x))),
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
  DoubleRawStringFormatted minimumOrder;
  DoubleRawStringFormatted underMinimumOrderDeliveryFee;
  DoubleRawStringFormatted fixedDeliveryFee;
  DoubleRawStringFormatted freeDeliveryThreshold;
  int minDeliveryMinutes;
  int maxDeliveryMinutes;

  factory BranchDelivery.fromJson(Map<String, dynamic> json) => BranchDelivery(
        isDeliveryEnabled: json["isDeliveryEnabled"],
        minimumOrder: DoubleRawStringFormatted.fromJson(json["minimumOrder"]),
        underMinimumOrderDeliveryFee: DoubleRawStringFormatted.fromJson(json["underMinimumOrderDeliveryFee"]),
        fixedDeliveryFee: DoubleRawStringFormatted.fromJson(json["fixedDeliveryFee"]),
        freeDeliveryThreshold: DoubleRawStringFormatted.fromJson(json["freeDeliveryThreshold"]),
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
