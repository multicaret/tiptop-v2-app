import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class CartProvider with ChangeNotifier {
  Cart marketCart;
  Cart foodCart;
  List<CartProduct> marketCartProducts = [];
  List<CartProduct> foodCartProducts = [];
  AddRemoveProductDataResponse addRemoveProductDataResponse;

  bool isLoadingAddRemoveRequest = false;
  bool isLoadingClearCartRequest = false;

  void setMarketCart(Cart _marketCart) {
    print(
        'setting market cart${_marketCart == null ? ' (null)' : ', marketCart id: ${_marketCart.id}'}, products count: ${_marketCart.products.length}');
    marketCart = _marketCart;
    marketCartProducts = _marketCart.products == null ? [] : _marketCart.products;
    clearRequestedMoreThanAvailableQuantity();
  }

  void setFoodCart(Cart _foodCart) {
    print('setting cart${_foodCart == null ? ' (null)' : ', marketCart id: ${_foodCart.id}'}, products count: ${_foodCart.products.length}');
    foodCart = _foodCart;
    foodCartProducts = _foodCart.products == null ? [] : _foodCart.products;
    clearRequestedMoreThanAvailableQuantity();
  }

  bool get noMarketCart =>
      marketCart == null ||
      marketCart.id == null ||
      marketCart.total.raw == null ||
      marketCart.total.raw == 0.0 ||
      marketCartProducts == null ||
      marketCart.productsCount == 0;

  bool get noFoodCart =>
      foodCart == null ||
      foodCart.id == null ||
      foodCart.total.raw == null ||
      foodCart.total.raw == 0.0 ||
      marketCartProducts == null ||
      foodCart.productsCount == 0;

  int getProductQuantity(int productId) {
    if (marketCart != null && marketCartProducts != null && marketCartProducts.length != 0) {
      CartProduct cartProduct = marketCartProducts.firstWhere((cartProduct) => cartProduct.product.id == productId, orElse: () => null);
      return cartProduct == null ? 0 : cartProduct.quantity;
    } else {
      return 0;
    }
  }

  Map<int, bool> requestedMoreThanAvailableQuantity = {};

  //Todo: optimize this function's code
  Future<int> addRemoveProduct({
    @required BuildContext context,
    @required AppProvider appProvider,
    @required bool isAdding,
    @required Product product,
  }) async {
    print('branch and chain ids from add remove products request:');
    print('${HomeProvider.branchId}, ${HomeProvider.chainId}');

    if (marketCart == null || marketCart.id == null) {
      print('No marketCart');
      showToast(msg: 'An Error Occurred! Logging out...');
      appProvider.logout(clearSelectedAddress: true);
      return null;
    }

    final endpoint = 'carts/${marketCart.id}/products/adjust-quantity';
    Map<String, dynamic> body = {
      'product_id': product.id,
      'chain_id': HomeProvider.chainId,
      'branch_id': HomeProvider.branchId,
      'is_adding': isAdding,
    };

    isLoadingAddRemoveRequest = true;

    requestedMoreThanAvailableQuantity[product.id] = false;
    List<CartProduct> _oldCartProducts = marketCartProducts;
    int oldProductQuantity = getProductQuantity(product.id);
    if (!isAdding && oldProductQuantity == 0) {
      return 0;
    }

    int requestedProductQuantity = isAdding
        ? oldProductQuantity + 1
        : oldProductQuantity == 1
            ? 0
            : oldProductQuantity - 1;

    if (!isAdding && oldProductQuantity == 1) {
      marketCartProducts = marketCartProducts.where((cartProduct) => cartProduct.product.id != product.id).toList();
      notifyListeners();
    } else if (oldProductQuantity == 0) {
      CartProduct _newTempCartProduct = CartProduct(
        product: product,
        quantity: requestedProductQuantity,
      );
      marketCartProducts.add(_newTempCartProduct);
      notifyListeners();
    } else {
      int requestedCartProductIndex = marketCartProducts.indexWhere((cartProduct) => cartProduct.product.id == product.id);
      marketCartProducts[requestedCartProductIndex].quantity = requestedProductQuantity;
      notifyListeners();
    }

    final responseData = await appProvider.post(
      endpoint: endpoint,
      body: body,
      withToken: true,
    );

    isLoadingAddRemoveRequest = false;
    if (responseData == 401) {
      //Sending authenticated request without logging in!
      marketCartProducts = _oldCartProducts;
      notifyListeners();
      showToast(msg: 'You need to log in first!');
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
      return null;
    }

    addRemoveProductDataResponse = AddRemoveProductDataResponse.fromJson(responseData);

    if (addRemoveProductDataResponse.status == 422) {
      requestedMoreThanAvailableQuantity[product.id] = true;
      int productAvailableQuantity = addRemoveProductDataResponse.cartData.availableQuantity;
      int requestedCartProductIndex = marketCartProducts.indexWhere((cartProduct) => cartProduct.product.id == product.id);
      marketCartProducts[requestedCartProductIndex].quantity = productAvailableQuantity;
      notifyListeners();
      showToast(msg: 'There are only $productAvailableQuantity available ${product.title}');
      return productAvailableQuantity;
    }

    if (addRemoveProductDataResponse.cartData == null || addRemoveProductDataResponse.status != 200) {
      marketCartProducts = _oldCartProducts;
      notifyListeners();
      throw HttpException(title: 'Http Exception Error', message: addRemoveProductDataResponse.message);
    }

    marketCart = addRemoveProductDataResponse.cartData.cart;
    notifyListeners();

    return getProductQuantity(product.id);
  }

  void clearRequestedMoreThanAvailableQuantity() {
    if (marketCartProducts != null && marketCartProducts.length > 0) {
      marketCartProducts.forEach((cartProduct) => requestedMoreThanAvailableQuantity[cartProduct.product.id] = false);
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
