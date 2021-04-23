import 'package:tiptop_v2/models/product.dart';

import 'models.dart';

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
        products: json["products"] == null ? <CartProduct>[] : List<CartProduct>.from(json["products"].map((x) => CartProduct.fromJson(x))),
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
  int productIdInCart;
  Product product;
  int quantity;

  CartProduct({
    this.productIdInCart,
    this.product,
    this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        productIdInCart: json["productIdInCart"],
        product: Product.fromJson(json["product"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "productIdInCart": productIdInCart,
        "product": product.toJson(),
        "quantity": quantity,
      };
}