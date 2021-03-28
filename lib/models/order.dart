import 'address.dart';
import 'cart.dart';
import 'models.dart';

class CreateCheckoutResponse {
  CreateCheckoutResponse({
    this.checkoutData,
    this.errors,
    this.message,
    this.status,
  });

  CheckoutData checkoutData;
  String errors;
  String message;
  int status;

  factory CreateCheckoutResponse.fromJson(Map<String, dynamic> json) => CreateCheckoutResponse(
        checkoutData: json["data"] == null ? null : CheckoutData.fromJson(json["data"]),
        errors: json["errors"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": checkoutData == null ? null : checkoutData.toJson(),
        "errors": errors,
        "message": message,
        "status": status,
      };
}

class CheckoutData {
  CheckoutData({
    this.paymentMethods,
    this.deliveryFee,
    this.total,
    this.grandTotal,
  });

  List<PaymentMethod> paymentMethods;
  DoubleRawIntFormatted deliveryFee;
  DoubleRawIntFormatted total;
  DoubleRawIntFormatted grandTotal;

  factory CheckoutData.fromJson(Map<String, dynamic> json) => CheckoutData(
        paymentMethods: List<PaymentMethod>.from(json["paymentMethods"].map((x) => PaymentMethod.fromJson(x))),
        deliveryFee: DoubleRawIntFormatted.fromJson(json["deliveryFee"]),
        total: DoubleRawIntFormatted.fromJson(json["total"]),
        grandTotal: DoubleRawIntFormatted.fromJson(json["grandTotal"]),
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

class SubmitOrderResponse {
  SubmitOrderResponse({
    this.submittedOrder,
    this.errors,
    this.message,
    this.status,
  });

  Order submittedOrder;
  String errors;
  String message;
  int status;

  factory SubmitOrderResponse.fromJson(Map<String, dynamic> json) => SubmitOrderResponse(
        submittedOrder: json["data"] == null ? null : Order.fromJson(json["data"]),
        errors: json["errors"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": submittedOrder.toJson(),
        "errors": errors,
        "message": message,
        "status": status,
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
    this.address,
    this.completedAt,
    this.deliveryFee,
    this.grandTotal,
    this.orderRating,
    this.cart,
    this.paymentMethod,
  });

  int id;
  Address address;
  EdAt completedAt;
  DoubleRawIntFormatted deliveryFee;
  DoubleRawIntFormatted grandTotal;
  OrderRating orderRating;
  Cart cart;
  PaymentMethod paymentMethod;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        address: Address.fromJson(json["address"]),
        completedAt: EdAt.fromJson(json["completedAt"]),
        deliveryFee: DoubleRawIntFormatted.fromJson(json["deliveryFee"]),
        grandTotal: DoubleRawIntFormatted.fromJson(json["grandTotal"]),
        orderRating: OrderRating.fromJson(json["rating"]),
        cart: Cart.fromJson(json["cart"]),
        paymentMethod: PaymentMethod.fromJson(json["paymentMethod"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
  OrderRatingAvailableIssue ratingIssue;

  factory OrderRating.fromJson(Map<String, dynamic> json) => OrderRating(
        branchHasBeenRated: json["branchHasBeenRated"],
        branchRatingValue: json["branchRatingValue"].toDouble(),
        driverHasBeenRated: json["driverHasBeenRated"],
        driverRatingValue: json["driverRatingValue"].toDouble(),
        ratingComment: json["ratingComment"],
        hasGoodFoodQualityRating: json["hasGoodFoodQualityRating"],
        hasGoodPackagingQualityRating: json["hasGoodPackagingQualityRating"],
        hasGoodOrderAccuracyRating: json["hasGoodOrderAccuracyRating"],
        ratingIssue: OrderRatingAvailableIssue.fromJson(json["ratingIssue"]),
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

class OrderRatingAvailableIssue {
  OrderRatingAvailableIssue({
    this.id,
    this.title,
  });

  int id;
  String title;

  factory OrderRatingAvailableIssue.fromJson(Map<String, dynamic> json) => OrderRatingAvailableIssue(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
