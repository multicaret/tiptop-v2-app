import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class CartProvider with ChangeNotifier {
  Cart cart;
  List<CartProduct> cartProducts;
  String cartTotal;
  double doubleCartTotal;
  int cartProductsCount = 0;
  AddRemoveProductDataResponse addRemoveProductDataResponse;
  bool requestedMoreThanAvailableQuantity = false;

  void setCart(Cart _cart) {
    print('setting cart, products count: ${_cart.products.length}');
    cart = _cart;
    cartTotal = _cart.total.formatted;
    doubleCartTotal = _cart.total.raw;
    cartProductsCount = _cart.productsCount > 0 ? _cart.productsCount : 0;
    cartProducts = _cart.products == null ? [] : _cart.products;
  }

  int getProductQuantity(int productId) {
    if (cart != null && cartProducts != null && cartProducts.length != 0) {
      CartProduct cartProduct = cartProducts.firstWhere((cartProduct) => cartProduct.product.id == productId, orElse: () => null);
      return cartProduct == null ? 0 : cartProduct.quantity;
    } else {
      return 0;
    }
  }

  Future<int> addRemoveProduct({
    @required BuildContext context,
    @required AppProvider appProvider,
    @required HomeProvider homeProvider,
    @required bool isAdding,
    @required int productId,
  }) async {
    final endpoint = 'baskets/add-remove-product';
    Map<String, dynamic> body = {
      'product_id': productId,
      'chain_id': homeProvider.chainId,
      'branch_id': homeProvider.branchId,
      'is_adding': isAdding,
    };

    requestedMoreThanAvailableQuantity = false;
    try {
      final responseData = await appProvider.post(
        endpoint: endpoint,
        body: body,
        withToken: true,
      );
      // print(responseData);

      if (responseData == 401) {
        //Sending authenticated request without logging in!
        showToast(msg: 'You need to log in first!');
        Navigator.of(context).pushReplacementNamed(WalkthroughPage.routeName);
        return null;
      }

      addRemoveProductDataResponse = AddRemoveProductDataResponse.fromJson(responseData);

      if (addRemoveProductDataResponse.status == 422) {
        requestedMoreThanAvailableQuantity = true;
        int productAvailableQuantity = addRemoveProductDataResponse.cartData.availableQuantity;
        print('product is not available, available quantity: $productAvailableQuantity');
        return productAvailableQuantity;
      }

      if (addRemoveProductDataResponse.cartData == null || addRemoveProductDataResponse.status != 200) {
        throw HttpException(title: 'Error', message: addRemoveProductDataResponse.message);
      }
      setCart(addRemoveProductDataResponse.cartData.cart);

      notifyListeners();

      return getProductQuantity(productId);
    } catch (e) {
      throw e;
    }
  }
}
