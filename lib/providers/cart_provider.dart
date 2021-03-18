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
  AddRemoveProductDataResponse addRemoveProductDataResponse;

  void setCart(Cart _cart) {
    cart = _cart;
    cartTotal = _cart.total.formatted;
    doubleCartTotal = _cart.total.raw;
    cartProducts = _cart.products == null ? [] : _cart.products;
  }

  Future<dynamic> addRemoveProduct({
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

    final responseData = await appProvider.post(
      endpoint: endpoint,
      body: body,
      withToken: true,
    );

    if (responseData == 401) {
      if (appProvider.token != null) {
        print('Sending authenticated request with expired token! Logging out...');
        appProvider.logout();
        return;
      } else {
        print('Sending authenticated request without logging in!');
        showToast(msg: 'You need to log in first!');
        Navigator.of(context).pushReplacementNamed(WalkthroughPage.routeName);
      }
    }

    addRemoveProductDataResponse = AddRemoveProductDataResponse.fromJson(responseData);

    if (addRemoveProductDataResponse.cartData == null || addRemoveProductDataResponse.status != 200) {
      throw HttpException(title: 'Error', message: addRemoveProductDataResponse.message);
    }

    setCart(addRemoveProductDataResponse.cartData.cart);

    notifyListeners();
  }
}
