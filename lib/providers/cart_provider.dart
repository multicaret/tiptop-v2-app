import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

class CartProvider with ChangeNotifier {
  Cart cart;
  List<Product> cartProducts;

  Future<dynamic> addRemoveProduct(
    AppProvider appProvider, {
    @required bool isAdding,
    @required int productId,
    //Todo: send chain id and branch dynamically
    int chainId = 1,
    int branchId = 3,
  }) async {
    final endpoint = 'baskets/add-remove-product';
    Map<String, dynamic> body = {
      'product_id': productId,
      'chain_id': chainId,
      'branch_id': branchId,
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
      } else {
        print('Sending authenticated request without logging in!');
        return 401;
      }
    }
  }
}
