import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class CartProvider with ChangeNotifier {
  Cart marketCart;
  Cart foodCart;

  bool isLoadingAdjustCartQuantityRequest = false;
  bool isLoadingAdjustFoodCartDataRequest = false;
  bool isLoadingClearCartRequest = false;

  void setMarketCart(Cart _marketCart) {
    print(
        'setting market cart${_marketCart == null ? ' (null)' : ', Market cart id: ${_marketCart.id}'}, products count: ${_marketCart.products.length}');
    marketCart = _marketCart;
    clearRequestedMoreThanAvailableQuantity();
  }

  void setFoodCart(Cart _foodCart) {
    print('setting food cart${_foodCart == null ? ' (null)' : ', Food Cart id: ${_foodCart.id}'}, products count: ${_foodCart.products.length}');
    foodCart = _foodCart;
    clearRequestedMoreThanAvailableQuantity();
  }

  bool get noMarketCart =>
      marketCart == null ||
      marketCart.id == null ||
      marketCart.total.raw == null ||
      marketCart.total.raw == 0.0 ||
      marketCart.productsCount == 0 ||
      marketCart.products == null ||
      marketCart.products.length == 0;

  bool get noFoodCart =>
      foodCart == null ||
      foodCart.id == null ||
      foodCart.total.raw == null ||
      foodCart.total.raw == 0.0 ||
      foodCart.productsCount == 0 ||
      foodCart.products == null ||
      foodCart.products.length == 0;

  int getProductQuantity(int productId) {
    if (marketCart != null && marketCart.products.length != 0) {
      CartProduct cartProduct = marketCart.products.firstWhere((cartProduct) => cartProduct.product.id == productId, orElse: () => null);
      return cartProduct == null ? 0 : cartProduct.quantity;
    } else {
      return 0;
    }
  }

  Map<int, bool> requestedMoreThanAvailableQuantity = {};
  Map<int, bool> isLoadingAdjustMarketProductQuantityRequest = {};

  Future<int> adjustMarketProductQuantity({
    @required AppProvider appProvider,
    @required bool isAdding,
    @required Product product,
    BuildContext context,
  }) async {
    if (marketCart == null || marketCart.id == null) {
      print('No marketCart');
      showToast(msg: Translations.of(context).get('An Error Occurred! Logging out...'));
      appProvider.logout(clearSelectedAddress: true);
      return 401;
    }

    if (HomeProvider.branchId == null || HomeProvider.chainId == null) {
      print('Cannot find branch id and/or chain id!');
      return null;
    }

    final endpoint = 'carts/${marketCart.id}/products/grocery/adjust-quantity';
    Map<String, dynamic> body = {
      'product_id': product.id,
      'chain_id': HomeProvider.chainId,
      'branch_id': HomeProvider.branchId,
      'is_adding': isAdding,
    };

    print('body');
    print(body);

    isLoadingAdjustCartQuantityRequest = true;
    isLoadingAdjustMarketProductQuantityRequest[product.id] = true;
    requestedMoreThanAvailableQuantity[product.id] = false;
    notifyListeners();

    final responseData = await appProvider.post(
      endpoint: endpoint,
      body: body,
      withToken: true,
      overrideStatusCheck: true,
    );

    if (responseData == 401) {
      return 401;
    }

    if ((responseData["data"] == null || responseData["status"] != 200) && responseData["status"] != 422) {
      print('adjust market cart product quantity response data');
      print(responseData);
      isLoadingAdjustCartQuantityRequest = false;
      isLoadingAdjustMarketProductQuantityRequest[product.id] = false;
      notifyListeners();
      throw HttpException(title: 'Http Exception Error', message: getHttpExceptionMessage(responseData));
    }

    CartData cartData = CartData.fromJson(responseData["data"]);

    if (responseData["data"] != null && responseData["status"] == 422) {
      print('adjust market cart product quantity response data');
      print(responseData);
      showToast(
        msg: Translations.of(context).get("There are only {cartAvailableQuantity} available {productTitle}",
            args: [responseData["data"]["availableQuantity"].toString(), product.title]),
      );
      requestedMoreThanAvailableQuantity[product.id] = true;
      isLoadingAdjustCartQuantityRequest = false;
      isLoadingAdjustMarketProductQuantityRequest[product.id] = false;
      notifyListeners();
      return null;
    }

    isLoadingAdjustCartQuantityRequest = false;
    isLoadingAdjustMarketProductQuantityRequest[product.id] = false;
    marketCart = cartData.cart;

    CartProduct adjustedProduct = marketCart.products.firstWhere((cartProduct) => cartProduct.product.id == product.id, orElse: () => null);
    if (adjustedProduct != null) {
      print('returned quantity: ${adjustedProduct.quantity}');
    } else {
      print('product not found! (or deleted from cart, hell if I know 🤷🏽‍)');
    }

    notifyListeners();

    return getProductQuantity(product.id);
  }

  Future<dynamic> adjustFoodProductCart(
    BuildContext context,
    AppProvider appProvider, {
    @required int productId,
    @required int chainId,
    @required int restaurantId,
    @required ProductCartData productTempCartData,
  }) async {
    if (foodCart == null || foodCart.id == null) {
      print('No food cart!');
      showToast(msg: Translations.of(context).get('An Error Occurred! Logging out...'));
      appProvider.logout(clearSelectedAddress: true);
      return 401;
    }
    isLoadingAdjustFoodCartDataRequest = true;
    notifyListeners();

    Map<String, dynamic> productCartData = {
      //Todo: fill first param when editing cart product
      'product_id_in_cart': null,
      'product_id': productId,
      'chain_id': chainId,
      'branch_id': restaurantId,
      'quantity': productTempCartData.quantity,
      'selected_options': productTempCartData.selectedOptions
          .where((selectedOption) => selectedOption.selectedIds.length > 0)
          .map((selectedOption) => {
                'product_option_id': selectedOption.productOptionId,
                'selected_ids': selectedOption.selectedIds,
              })
          .toList(),
    };

    print('productCartData on submitting....');
    print(productCartData);

    final endpoint = 'carts/${foodCart.id}/products/food/adjust-cart-data';
    // try {
      final responseData = await appProvider.post(endpoint: endpoint, body: productCartData, withToken: true);
      if (responseData == 401) {
        return 401;
      }
      CartData cartData = CartData.fromJson(responseData["data"]);
      isLoadingAdjustFoodCartDataRequest = false;
      foodCart = cartData.cart;
      notifyListeners();
/*    } catch (e) {
      // showToast(msg: Translations.of(context).get('An Error Occurred!'));
      isLoadingAdjustFoodCartDataRequest = false;
      notifyListeners();
      throw e;
    }*/
  }

  void clearRequestedMoreThanAvailableQuantity() {
    if (marketCart != null && marketCart.products != null && marketCart.products.length > 0) {
      marketCart.products.forEach((cartProduct) => requestedMoreThanAvailableQuantity[cartProduct.product.id] = false);
    }
  }

  Future<void> clearCart(AppProvider appProvider) async {
    final endpoint = 'carts/${marketCart.id}/delete';
    clearRequestedMoreThanAvailableQuantity();
    isLoadingClearCartRequest = true;
    notifyListeners();

    Map<String, dynamic> body = {
      'branch_id': HomeProvider.branchId,
      'chain_id': HomeProvider.chainId,
    };

    try {
      await appProvider.post(
        endpoint: endpoint,
        body: body,
        withToken: true,
      );

      isLoadingClearCartRequest = false;
      notifyListeners();
    } catch (e) {
      isLoadingClearCartRequest = true;
      notifyListeners();
      throw e;
    }
  }
}
