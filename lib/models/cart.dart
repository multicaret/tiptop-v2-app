import 'package:tiptop_v2/models/product.dart';

import 'branch.dart';
import 'home.dart';
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
    this.cartProducts,
    this.restaurant,
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
  List<CartProduct> cartProducts;
  Branch restaurant;

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
        cartProducts: json["products"] == null ? <CartProduct>[] : List<CartProduct>.from(json["products"].map((x) => CartProduct.fromJson(x))),
        restaurant: json["restaurant"] == null ? null : Branch.fromJson(json["restaurant"]),
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
        "products": List<dynamic>.from(cartProducts.map((x) => x.toJson())),
        "restaurant": restaurant == null ? null : restaurant.toJson(),
      };
}

class CartProduct {
  int cartProductId;
  Product product;
  int quantity;
  DoubleRawStringFormatted price;
  DoubleRawStringFormatted totalPrice;
  List<ProductSelectedOption> selectedOptions;

  CartProduct({
    this.cartProductId,
    this.product,
    this.quantity,
    this.price,
    this.totalPrice,
    this.selectedOptions,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        cartProductId: json["cartProductId"],
        product: Product.fromJson(json["product"]),
        quantity: json["quantity"],
        price: json["price"] == null ? null : DoubleRawStringFormatted.fromJson(json["price"]),
        totalPrice: json["totalPrice"] == null ? null : DoubleRawStringFormatted.fromJson(json["totalPrice"]),
        selectedOptions: json["selectedOptions"] == null
            ? <ProductSelectedOption>[]
            : List<ProductSelectedOption>.from(json["selectedOptions"].map((x) => ProductSelectedOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cartProductId": cartProductId,
        "product": product.toJson(),
        "quantity": quantity,
      };
}
