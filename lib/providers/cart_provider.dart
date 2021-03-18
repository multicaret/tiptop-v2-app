import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';

class CartProvider with ChangeNotifier {
  Cart cart;
  List<CartProduct> cartProducts;

  Future<dynamic> addRemoveProduct({
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
        return 401;
      }
    }
  }
}
