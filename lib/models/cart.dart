import 'package:tiptop_v2/models/product.dart';

class AddRemoveProductDataResponse {
  AddRemoveProductDataResponse({
    this.addRemoveProductData,
    this.errors,
    this.message,
    this.status,
  });

  AddRemoveProductData addRemoveProductData;
  String errors;
  String message;
  int status;

  factory AddRemoveProductDataResponse.fromJson(Map<String, dynamic> json) => AddRemoveProductDataResponse(
        addRemoveProductData: json["data"] == null ? null : AddRemoveProductData.fromJson(json["data"]),
        errors: json["errors"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": addRemoveProductData.toJson(),
        "errors": errors,
        "message": message,
        "status": status,
      };
}

class AddRemoveProductData {
  AddRemoveProductData({
    this.cart,
    this.quantity,
  });

  Cart cart;
  int quantity;

  factory AddRemoveProductData.fromJson(Map<String, dynamic> json) => AddRemoveProductData(
        cart: Cart.fromJson(json["basket"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "cart": cart.toJson(),
        "quantity": quantity,
      };
}

class Cart {
  Cart({
    this.id,
    this.productsCount,
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
  int status;
  String createdAt;
  String updatedAt;
  int userId;
  int chainId;
  int branchId;
  List<Product> products;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        productsCount: json["productsCount"],
        status: json["status"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        userId: json["userId"],
        chainId: json["chainId"],
        branchId: json["branchId"],
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
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
