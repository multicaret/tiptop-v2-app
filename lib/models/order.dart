import 'address.dart';
import 'cart.dart';
import 'enums.dart';
import 'models.dart';

class CheckoutData {
  CheckoutData({
    this.paymentMethods,
    this.deliveryFee,
    this.total,
    this.grandTotal,
  });

  List<PaymentMethod> paymentMethods;
  DoubleRawStringFormatted deliveryFee;
  DoubleRawStringFormatted total;
  DoubleRawStringFormatted grandTotal;

  factory CheckoutData.fromJson(Map<String, dynamic> json) => CheckoutData(
        paymentMethods: List<PaymentMethod>.from(json["paymentMethods"].map((x) => PaymentMethod.fromJson(x))),
        deliveryFee: DoubleRawStringFormatted.fromJson(json["deliveryFee"]),
        total: DoubleRawStringFormatted.fromJson(json["total"]),
        grandTotal: DoubleRawStringFormatted.fromJson(json["grandTotal"]),
      );

  Map<String, dynamic> toJson() => {
        "paymentMethods": List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
        "deliveryFee": deliveryFee,
        "total": total,
        "grandTotal": grandTotal,
      };
}

class PaymentMethod {
  PaymentMethod({
    this.id,
    this.title,
    this.description,
    this.instructions,
    this.logo,
  });

  int id;
  String title;
  dynamic description;
  dynamic instructions;
  String logo;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        instructions: json["instructions"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "instructions": instructions,
        "logo": logo,
      };
}

class PreviousOrdersResponseData {
  PreviousOrdersResponseData({
    this.previousOrders,
    this.errors,
    this.message,
    this.status,
  });

  List<Order> previousOrders;
  dynamic errors;
  String message;
  int status;

  factory PreviousOrdersResponseData.fromJson(Map<String, dynamic> json) => PreviousOrdersResponseData(
        previousOrders: json["data"] == null ? null : List<Order>.from(json["data"].map((x) => Order.fromJson(x))),
        errors: json["errors"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": previousOrders == null ? null : List<dynamic>.from(previousOrders.map((x) => x.toJson())),
        "errors": errors,
        "message": message,
        "status": status,
      };
}

class Order {
  Order({
    this.id,
    this.referenceCode,
    this.address,
    this.completedAt,
    this.deliveryType,
    this.couponCode,
    this.couponDiscountAmount,
    this.totalAfterCouponDiscount,
    this.deliveryFee,
    this.grandTotal,
    this.orderRating,
    this.status,
    this.statusName,
    this.driverName,
    this.driverAvatar,
    this.trackingLink,
    this.cart,
    this.paymentMethod,
  });

  int id;
  int referenceCode;
  Address address;
  EdAt completedAt;
  RestaurantDeliveryType deliveryType;
  String couponCode;
  DoubleRawStringFormatted couponDiscountAmount;
  DoubleRawStringFormatted totalAfterCouponDiscount;
  DoubleRawStringFormatted deliveryFee;
  DoubleRawStringFormatted grandTotal;
  OrderRating orderRating;
  OrderStatus status;
  String statusName;
  String driverName;
  String driverAvatar;
  String trackingLink;
  Cart cart;
  PaymentMethod paymentMethod;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        referenceCode: json["referenceCode"],
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        deliveryType: json["deliveryType"] == null ? null : restaurantDeliveryTypeValues.map[json["deliveryType"]],
        completedAt: EdAt.fromJson(json["completedAt"]),
        couponCode: json["couponCode"],
        couponDiscountAmount: json["couponDiscountAmount"] == null ? null : DoubleRawStringFormatted.fromJson(json["couponDiscountAmount"]),
        totalAfterCouponDiscount:
            json["totalAfterCouponDiscount"] == null ? null : DoubleRawStringFormatted.fromJson(json["totalAfterCouponDiscount"]),
        deliveryFee: DoubleRawStringFormatted.fromJson(json["deliveryFee"]),
        grandTotal: DoubleRawStringFormatted.fromJson(json["grandTotal"]),
        orderRating: OrderRating.fromJson(json["rating"]),
        status: json["status"] == null ? null : orderStatusValues.map[json["status"].toString()],
        statusName: json["statusName"],
        driverName: json["driverName"],
        driverAvatar: json["driverAvatar"],
        trackingLink: json["trackingLink"],
        cart: json["cart"] == null ? null : Cart.fromJson(json["cart"]),
        paymentMethod: PaymentMethod.fromJson(json["paymentMethod"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "referenceCode": referenceCode,
        "address": address.toJson(),
        "completedAt": completedAt.toJson(),
        "deliveryFee": deliveryFee.toJson(),
        "grandTotal": grandTotal.toJson(),
        "rating": orderRating.toJson(),
        "cart": cart.toJson(),
        "paymentMethod": paymentMethod.toJson(),
      };
}

class OrderRating {
  OrderRating({
    this.branchHasBeenRated,
    this.branchRatingValue,
    this.driverHasBeenRated,
    this.driverRatingValue,
    this.ratingComment,
    this.hasGoodFoodQualityRating,
    this.hasGoodPackagingQualityRating,
    this.hasGoodOrderAccuracyRating,
    this.ratingIssue,
  });

  bool branchHasBeenRated;
  double branchRatingValue;
  bool driverHasBeenRated;
  double driverRatingValue;
  String ratingComment;
  bool hasGoodFoodQualityRating;
  bool hasGoodPackagingQualityRating;
  bool hasGoodOrderAccuracyRating;
  MarketOrderRatingAvailableIssue ratingIssue;

  factory OrderRating.fromJson(Map<String, dynamic> json) => OrderRating(
        branchHasBeenRated: json["branchHasBeenRated"],
        branchRatingValue: json["branchRatingValue"].toDouble(),
        driverHasBeenRated: json["driverHasBeenRated"],
        driverRatingValue: json["driverRatingValue"].toDouble(),
        ratingComment: json["ratingComment"],
        hasGoodFoodQualityRating: json["hasGoodFoodQualityRating"],
        hasGoodPackagingQualityRating: json["hasGoodPackagingQualityRating"],
        hasGoodOrderAccuracyRating: json["hasGoodOrderAccuracyRating"],
        ratingIssue: MarketOrderRatingAvailableIssue.fromJson(json["ratingIssue"]),
      );

  Map<String, dynamic> toJson() => {
        "branchHasBeenRated": branchHasBeenRated,
        "branchRatingValue": branchRatingValue,
        "driverHasBeenRated": driverHasBeenRated,
        "driverRatingValue": driverRatingValue,
        "ratingComment": ratingComment,
        "hasGoodFoodQualityRating": hasGoodFoodQualityRating,
        "hasGoodPackagingQualityRating": hasGoodPackagingQualityRating,
        "hasGoodOrderAccuracyRating": hasGoodOrderAccuracyRating,
        "ratingIssue": ratingIssue.toJson(),
      };
}

class MarketOrderRatingAvailableIssue {
  MarketOrderRatingAvailableIssue({
    this.id,
    this.title,
  });

  int id;
  String title;

  factory MarketOrderRatingAvailableIssue.fromJson(Map<String, dynamic> json) => MarketOrderRatingAvailableIssue(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}

class FoodOrderRatingFactors {
  FoodOrderRatingFactors({
    this.key,
    this.label,
  });

  String key;
  String label;

  factory FoodOrderRatingFactors.fromJson(Map<String, dynamic> json) => FoodOrderRatingFactors(
        key: json["key"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "label": label,
      };
}

class CouponValidationData {
  CouponValidationData({
    this.discountedAmount,
    this.deliveryFee,
    this.totalBefore,
    this.totalAfter,
    this.grandTotal,
  });

  DoubleRawStringFormatted discountedAmount;
  DoubleRawStringFormatted deliveryFee;
  DoubleRawStringFormatted totalBefore;
  DoubleRawStringFormatted totalAfter;
  DoubleRawStringFormatted grandTotal;

  factory CouponValidationData.fromJson(Map<String, dynamic> json) => CouponValidationData(
        discountedAmount: DoubleRawStringFormatted.fromJson(json["discountedAmount"]),
        deliveryFee: DoubleRawStringFormatted.fromJson(json["deliveryFee"]),
        totalBefore: DoubleRawStringFormatted.fromJson(json["totalBefore"]),
        totalAfter: DoubleRawStringFormatted.fromJson(json["totalAfter"]),
        grandTotal: DoubleRawStringFormatted.fromJson(json["grandTotal"]),
      );
}
