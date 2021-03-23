import 'package:tiptop_v2/models/product.dart';

import 'models.dart';

class AddRemoveProductDataResponse {
  AddRemoveProductDataResponse({
    this.cartData,
    this.errors,
    this.message,
    this.status,
  });

  CartData cartData;
  String errors;
  String message;
  int status;

  factory AddRemoveProductDataResponse.fromJson(Map<String, dynamic> json) => AddRemoveProductDataResponse(
        cartData: json["data"] == null ? null : CartData.fromJson(json["data"]),
        errors: json["errors"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": cartData.toJson(),
        "errors": errors,
        "message": message,
        "status": status,
      };
}

class CartData {
  CartData({
    this.cart,
    this.availableQuantity,
  });

  Cart cart;
  int availableQuantity;

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        cart: json["cart"] == null ? null : Cart.fromJson(json["cart"]),
        availableQuantity: json["availableQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "cart": cart.toJson(),
        "availableQuantity": availableQuantity,
      };
}

class Cart {
  Cart({
    this.id,
    this.productsCount,
    this.total,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.chainId,
    this.branchId,
    this.products,
  });

  int id;
  int productsCount;
  DoubleRawStringFormatted total;
  int status;
  String createdAt;
  String updatedAt;
  int userId;
  int chainId;
  int branchId;
  List<CartProduct> products;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        productsCount: json["productsCount"],
        total: DoubleRawStringFormatted.fromJson(json["total"]),
        status: json["status"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        userId: json["userId"],
        chainId: json["chainId"],
        branchId: json["branchId"],
        products: List<CartProduct>.from(json["products"].map((x) => CartProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productsCount": productsCount,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "userId": userId,
        "chainId": chainId,
        "branchId": branchId,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class CartProduct {
  Product product;
  int quantity;

  CartProduct({
    this.product,
    this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        product: Product.fromJson(json["product"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "quantity": quantity,
      };
}

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
  Price deliveryFee;
  Price total;
  Price grandTotal;

  factory CheckoutData.fromJson(Map<String, dynamic> json) => CheckoutData(
    paymentMethods: List<PaymentMethod>.from(json["paymentMethods"].map((x) => PaymentMethod.fromJson(x))),
    deliveryFee: Price.fromJson(json["deliveryFee"]),
    total: Price.fromJson(json["total"]),
    grandTotal: Price.fromJson(json["grandTotal"]),
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
    this.title,
    this.description,
    this.instructions,
    this.logo,
  });

  String title;
  dynamic description;
  dynamic instructions;
  String logo;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    title: json["title"],
    description: json["description"],
    instructions: json["instructions"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "instructions": instructions,
    "logo": logo,
  };
}