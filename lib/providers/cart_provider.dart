import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class CartProvider with ChangeNotifier {
  Cart cart;
  List<CartProduct> cartProducts;
  String cartTotal = '';
  double doubleCartTotal = 0.0;
  int cartProductsCount = 0;
  AddRemoveProductDataResponse addRemoveProductDataResponse;
  bool isLoadingAddRemoveRequest = false;

  void setCart(Cart _cart) {
    print('setting cart, products count: ${_cart.products.length}');
    cart = _cart;
    cartTotal = _cart.total.formatted;
    doubleCartTotal = _cart.total.raw;
    cartProductsCount = _cart.productsCount > 0 ? _cart.productsCount : 0;
    cartProducts = _cart.products == null ? [] : _cart.products;
  }

  bool noCart() {
    return cart == null || doubleCartTotal == null || doubleCartTotal == 0.0 || cartProducts == null || cartProductsCount == 0;
  }

  int getProductQuantity(int productId) {
    if (cart != null && cartProducts != null && cartProducts.length != 0) {
      CartProduct cartProduct = cartProducts.firstWhere((cartProduct) => cartProduct.product.id == productId, orElse: () => null);
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
    @required HomeProvider homeProvider,
    @required bool isAdding,
    @required Product product,
  }) async {
    final endpoint = 'carts/add-remove-product';
    Map<String, dynamic> body = {
      'product_id': product.id,
      'chain_id': homeProvider.chainId,
      'branch_id': homeProvider.branchId,
      'is_adding': isAdding,
    };

    isLoadingAddRemoveRequest = true;

    requestedMoreThanAvailableQuantity[product.id] = false;
    List<CartProduct> _oldCartProducts = cartProducts;
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
      cartProducts = cartProducts.where((cartProduct) => cartProduct.product.id != product.id).toList();
      notifyListeners();
    } else if (oldProductQuantity == 0) {
      CartProduct _newTempCartProduct = CartProduct(
        product: product,
        quantity: requestedProductQuantity,
      );
      cartProducts.add(_newTempCartProduct);
      notifyListeners();
    } else {
      int requestedCartProductIndex = cartProducts.indexWhere((cartProduct) => cartProduct.product.id == product.id);
      cartProducts[requestedCartProductIndex].quantity = requestedProductQuantity;
      notifyListeners();
    }

    // try {
    final responseData = await appProvider.post(
      endpoint: endpoint,
      body: body,
      withToken: true,
    );
    // print(responseData);
    isLoadingAddRemoveRequest = false;
    if (responseData == 401) {
      //Sending authenticated request without logging in!
      cartProducts = _oldCartProducts;
      notifyListeners();
      showToast(msg: 'You need to log in first!');
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
      return null;
    }

    if (responseData == null) {
      cartProducts = _oldCartProducts;
      notifyListeners();
      return null;
    }

    addRemoveProductDataResponse = AddRemoveProductDataResponse.fromJson(responseData);

    if (addRemoveProductDataResponse.status == 422) {
      requestedMoreThanAvailableQuantity[product.id] = true;
      int productAvailableQuantity = addRemoveProductDataResponse.cartData.availableQuantity;
      int requestedCartProductIndex = cartProducts.indexWhere((cartProduct) => cartProduct.product.id == product.id);
      cartProducts[requestedCartProductIndex].quantity = productAvailableQuantity;
      notifyListeners();
      showToast(msg: 'There are only $productAvailableQuantity available ${product.title}');
      return productAvailableQuantity;
    }

    if (addRemoveProductDataResponse.cartData == null || addRemoveProductDataResponse.status != 200) {
      cartProducts = _oldCartProducts;
      notifyListeners();
      throw HttpException(title: 'Error', message: addRemoveProductDataResponse.message);
    }

    // setCart(addRemoveProductDataResponse.cartData.cart);
    cart = addRemoveProductDataResponse.cartData.cart;
    cartTotal = cart.total.formatted;
    doubleCartTotal = cart.total.raw;
    cartProductsCount = cart.productsCount > 0 ? cart.productsCount : 0;
    notifyListeners();

    return getProductQuantity(product.id);
    // } catch (e) {
    //   throw e;
    // }
  }
}
