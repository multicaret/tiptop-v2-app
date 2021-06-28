import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

import 'local_storage.dart';

class CartProvider with ChangeNotifier {
  Cart marketCart;
  Cart foodCart;

  bool isLoadingAdjustCartQuantityRequest = false;
  bool isLoadingAdjustFoodCartDataRequest = false;
  bool isLoadingClearMarketCartRequest = false;
  bool isLoadingClearFoodCartRequest = false;
  bool isLoadingDeleteFoodCartProduct = false;
  bool isLoadingDeleteMarketCartProduct = false;

  LocalStorage storageActions = LocalStorage.getActions();

  void setMarketCart(Cart _marketCart) {
    print(
        'setting market cart${_marketCart == null ? ' (null)' : ', Market cart id: ${_marketCart.id}'}, products count: ${_marketCart.cartProducts.length}');
    marketCart = _marketCart;
    clearRequestedMoreThanAvailableQuantity();
  }

  void setFoodCart(Cart _foodCart) {
    print('setting food cart${_foodCart == null ? ' (null)' : ', Food Cart id: ${_foodCart.id}'}, products count: ${_foodCart.cartProducts.length}');
    foodCart = _foodCart;
    clearRequestedMoreThanAvailableQuantity();
  }

  bool get noMarketCart =>
      marketCart == null ||
      marketCart.id == null ||
      marketCart.total.raw == null ||
      marketCart.total.raw == 0.0 ||
      marketCart.productsCount == 0 ||
      marketCart.cartProducts == null ||
      marketCart.cartProducts.length == 0;

  bool get noFoodCart =>
      foodCart == null ||
      foodCart.id == null ||
      foodCart.total.raw == null ||
      foodCart.total.raw == 0.0 ||
      foodCart.productsCount == 0 ||
      foodCart.cartProducts == null ||
      foodCart.cartProducts.length == 0;

  int getProductQuantity(int productId) {
    if (marketCart != null && marketCart.cartProducts.length != 0) {
      CartProduct cartProduct = marketCart.cartProducts.firstWhere((cartProduct) => cartProduct.product.id == productId, orElse: () => null);
      return cartProduct == null ? 0 : cartProduct.quantity;
    } else {
      return 0;
    }
  }

  Map<int, bool> requestedMoreThanAvailableQuantity = {};
  Map<int, bool> isLoadingAdjustMarketProductQuantityRequest = {};
  Map<int, bool> isLoadingAdjustFoodProductQuantityRequest = {};

  Future<int> adjustMarketProductQuantity({
    @required AppProvider appProvider,
    @required bool isAdding,
    @required Product product,
    BuildContext context,
  }) async {
    if (marketCart == null || marketCart.id == null) {
      print('No marketCart');
      showToast(msg: Translations.of(context).get("An Error Occurred! Logging out..."));
      appProvider.logout();
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
      throw HttpException(
        title: 'Http Exception Error',
        message: getHttpExceptionMessage(responseData),
      );
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

    CartProduct adjustedProduct = marketCart.cartProducts.firstWhere((cartProduct) => cartProduct.product.id == product.id, orElse: () => null);
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
    int cartProductId,
    @required int chainId,
    @required int restaurantId,
    @required ProductCartData productTempCartData,
    bool deleteExistingCart = false,
    bool adjustingQuantity = false,
  }) async {
    if (foodCart == null || foodCart.id == null) {
      print('No food cart!');
      showToast(msg: Translations.of(context).get("An Error Occurred! Logging out..."));
      appProvider.logout();
      return 401;
    }
    if (adjustingQuantity) {
      isLoadingAdjustFoodProductQuantityRequest[cartProductId] = true;
    }
    isLoadingAdjustFoodCartDataRequest = true;
    notifyListeners();

    Map<String, dynamic> productCartData = {
      //Todo: fill first param when editing cart product
      'cart_product_id': cartProductId,
      'product_id': productId,
      'chain_id': chainId,
      'branch_id': restaurantId,
      'quantity': productTempCartData.quantity,
      'selected_options': productTempCartData.selectedOptions
          .where((selectedOption) => selectedOption.selectionIds.length > 0)
          .map((selectedOption) => {
                'product_option_id': selectedOption.productOptionId,
                'selected_ids': selectedOption.selectionIds,
              })
          .toList(),
    };

    print('productCartData on submitting....');
    print(productCartData);

    final endpoint = 'carts/${foodCart.id}/products/food/adjust-cart-data';
    try {
      if (deleteExistingCart) {
        await clearFoodCart(context, appProvider, shouldNavigateToHome: false);
      }
      final responseData = await appProvider.post(endpoint: endpoint, body: productCartData, withToken: true);
      if (responseData == 401) {
        appProvider.logout();
        return 401;
      }
      CartData cartData = CartData.fromJson(responseData["data"]);
      if (adjustingQuantity) {
        isLoadingAdjustFoodProductQuantityRequest[cartProductId] = false;
      }
      isLoadingAdjustFoodCartDataRequest = false;
      foodCart = cartData.cart;
      if (HomeProvider.selectedFoodBranchId == null && HomeProvider.selectedFoodChainId == null) {
        HomeProvider.selectedFoodBranchId = foodCart.branchId;
        HomeProvider.selectedFoodChainId = foodCart.chainId;
        print('Saving food branch id and chain id to local storage...');
        await storageActions.save(key: 'selected_food_branch_id', data: foodCart.branchId);
        await storageActions.save(key: 'selected_food_chain_id', data: foodCart.chainId);
      }
      notifyListeners();
    } catch (e) {
      // showToast(msg: Translations.of(context).get("An Error Occurred!"));
      isLoadingAdjustFoodCartDataRequest = false;
      if (adjustingQuantity) {
        isLoadingAdjustFoodProductQuantityRequest[cartProductId] = false;
      }
      notifyListeners();
      throw e;
    }
  }

  Future<void> deleteProductFromMarketCart({BuildContext context, AppProvider appProvider, int productId}) async {
    if (marketCart == null || marketCart.id == null) {
      print('No Market cart!');
      showToast(msg: Translations.of(context).get("An Error Occurred! Logging out..."));
      appProvider.logout();
      return 401;
    }

    if (HomeProvider.branchId == null || HomeProvider.chainId == null) {
      print('Either chain id (${HomeProvider.chainId}) or restaurant id (${HomeProvider.branchId}) is null');
      return;
    }

    // clearRequestedMoreThanAvailableQuantity();
    isLoadingDeleteMarketCartProduct = true;
    notifyListeners();

    Map<String, dynamic> body = {
      'branch_id': HomeProvider.branchId,
      'chain_id': HomeProvider.chainId,
    };
    print('body: $body');

    final endpoint = 'carts/${marketCart.id}/products/grocery/$productId/delete';

    try {
      final responseData = await appProvider.post(
        endpoint: endpoint,
        body: body,
        withToken: true,
      );

      marketCart = Cart.fromJson(responseData["data"]["cart"]);
      showToast(msg: Translations.of(context).get("Successfully deleted from cart!"));
      isLoadingDeleteMarketCartProduct = false;
      notifyListeners();
    } catch (e) {
      isLoadingDeleteMarketCartProduct = true;
      showToast(msg: Translations.of(context).get("Error deleting from cart!"));
      notifyListeners();
      throw e;
    }
  }

  Future<void> deleteProductFromFoodCart({BuildContext context, AppProvider appProvider, int cartProductId}) async {
    if (foodCart == null || foodCart.id == null) {
      print('No food cart!');
      showToast(msg: Translations.of(context).get("An Error Occurred! Logging out..."));
      appProvider.logout();
      return 401;
    }

    if (HomeProvider.selectedFoodBranchId == null || HomeProvider.selectedFoodChainId == null) {
      print('Either chain id (${HomeProvider.selectedFoodChainId}) or restaurant id (${HomeProvider.selectedFoodBranchId}) is null');
      return;
    }

    // clearRequestedMoreThanAvailableQuantity();
    isLoadingDeleteFoodCartProduct = true;
    notifyListeners();

    Map<String, dynamic> body = {
      'branch_id': HomeProvider.selectedFoodBranchId,
      'chain_id': HomeProvider.selectedFoodChainId,
    };
    print('body: $body');

    final endpoint = 'carts/${foodCart.id}/products/food/$cartProductId}/delete';

    try {
      final responseData = await appProvider.post(
        endpoint: endpoint,
        body: body,
        withToken: true,
      );

      foodCart = Cart.fromJson(responseData["data"]["cart"]);
      showToast(msg: Translations.of(context).get("Successfully deleted from cart!"));
      isLoadingDeleteFoodCartProduct = false;
      notifyListeners();
    } catch (e) {
      isLoadingDeleteFoodCartProduct = true;
      showToast(msg: Translations.of(context).get("Error deleting from cart!"));
      notifyListeners();
      throw e;
    }
  }

  void clearRequestedMoreThanAvailableQuantity() {
    if (marketCart != null && marketCart.cartProducts != null && marketCart.cartProducts.length > 0) {
      marketCart.cartProducts.forEach((cartProduct) => requestedMoreThanAvailableQuantity[cartProduct.product.id] = false);
    }
  }

  Future<void> clearMarketCart(AppProvider appProvider) async {
    final endpoint = 'carts/${marketCart.id}/delete';
    clearRequestedMoreThanAvailableQuantity();
    isLoadingClearMarketCartRequest = true;
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

      isLoadingClearMarketCartRequest = false;
      notifyListeners();
    } catch (e) {
      isLoadingClearMarketCartRequest = true;
      notifyListeners();
      throw e;
    }
  }

  Future<void> clearFoodCart(BuildContext context, AppProvider appProvider, {bool shouldNavigateToHome = true}) async {
    final endpoint = 'carts/${foodCart.id}/delete';

    if (HomeProvider.selectedFoodBranchId == null || HomeProvider.selectedFoodChainId == null) {
      print('Either chain id (${HomeProvider.selectedFoodChainId}) or restaurant id (${HomeProvider.selectedFoodBranchId}) is null');
      return;
    }

    // clearRequestedMoreThanAvailableQuantity();
    isLoadingClearFoodCartRequest = true;
    notifyListeners();

    Map<String, dynamic> body = {
      'branch_id': HomeProvider.selectedFoodBranchId,
      'chain_id': HomeProvider.selectedFoodChainId,
    };
    print('body: $body');

    try {
      await appProvider.post(
        endpoint: endpoint,
        body: body,
        withToken: true,
      );

      print('Deleting chain id and branch id from local storage...');
      await storageActions.deleteData(key: 'selected_food_branch_id');
      await storageActions.deleteData(key: 'selected_food_chain_id');
      HomeProvider.selectedFoodBranchId = null;
      HomeProvider.selectedFoodChainId = null;

      isLoadingClearFoodCartRequest = false;
      if (shouldNavigateToHome) {
        showToast(msg: Translations.of(context).get("Cart Cleared Successfully!"));
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(AppWrapper.routeName, (Route<dynamic> route) => false);
      }
      notifyListeners();
    } catch (e) {
      showToast(msg: Translations.of(context).get("Error clearing cart!"));
      isLoadingClearFoodCartRequest = true;
      notifyListeners();
      throw e;
    }
  }
}
