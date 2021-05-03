import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

import 'app_provider.dart';
import 'cart_provider.dart';
import 'home_provider.dart';
import 'local_storage.dart';

class OrdersProvider with ChangeNotifier {
  Order submittedMarketOrder;
  Order submittedFoodOrder;
  PreviousOrdersResponseData previousOrdersResponseData;
  List<Order> marketPreviousOrders = [];
  List<Order> foodPreviousOrders = [];
  Order order;

  CheckoutData checkoutData;
  bool isLoadingDeleteOrderRequest = false;
  CouponValidationData couponValidationData;

  List<MarketOrderRatingAvailableIssue> marketOrderRatingAvailableIssues = [];
  List<FoodOrderRatingFactors> foodOrderRatingFactors = [];

  LocalStorage storageActions = LocalStorage.getActions();

  Future<dynamic> createMarketOrderAndGetCheckoutData(AppProvider appProvider, int selectedAddressId) async {
    final endpoint = 'orders/create';
    Map<String, String> body = {
      'chain_id': '${HomeProvider.chainId}',
      'branch_id': '${HomeProvider.branchId}',
      'selected_address_id': '$selectedAddressId',
    };
    final responseData = await appProvider.get(
      endpoint: endpoint,
      body: body,
      withToken: true,
    );

    if (responseData == 401) {
      return 401;
    }

    checkoutData = CheckoutData.fromJson(responseData["data"]);
    notifyListeners();
  }

  Future<dynamic> createFoodOrderAndGetCheckoutData(AppProvider appProvider, int selectedAddressId) async {
    final endpoint = 'orders/create';
    if (HomeProvider.selectedFoodBranchId == null || HomeProvider.selectedFoodChainId == null) {
      print('Either chain id (${HomeProvider.selectedFoodChainId}) or restaurant id (${HomeProvider.selectedFoodBranchId}) is null');
      return;
    }

    Map<String, String> body = {
      'chain_id': '${HomeProvider.selectedFoodChainId}',
      'branch_id': '${HomeProvider.selectedFoodBranchId}',
      'selected_address_id': '$selectedAddressId',
    };
    final responseData = await appProvider.get(
      endpoint: endpoint,
      body: body,
      withToken: true,
    );
    print('create food order response:');
    print(responseData);

    if (responseData == 401) {
      return 401;
    }

    checkoutData = CheckoutData.fromJson(responseData["data"]);
    notifyListeners();
  }

  Future<void> submitMarketOrder(
    AppProvider appProvider,
    CartProvider cartProvider,
    AddressesProvider addressesProvider, {
    @required int paymentMethodId,
    @required String notes,
    String couponCode,
  }) async {
    if (cartProvider.noMarketCart) {
      print('No current cart!');
      return false;
    }

    cartProvider.clearRequestedMoreThanAvailableQuantity();

    if (addressesProvider.selectedAddress == null) {
      print('No address selected!');
      return false;
    }

    Map<String, dynamic> body = {
      'branch_id': HomeProvider.branchId,
      'chain_id': HomeProvider.chainId,
      'cart_id': cartProvider.marketCart.id,
      'payment_method_id': paymentMethodId,
      'selected_address_id': addressesProvider.selectedAddress.id,
      'notes': notes,
      'coupon_redeem_code': couponCode,
    };

    print('Order submit request body:');
    print(body);

    final endpoint = 'orders';
    final responseData = await appProvider.post(
      endpoint: endpoint,
      body: body,
      withToken: true,
    );

    submittedMarketOrder = Order.fromJson(responseData["data"]);
    notifyListeners();
  }

  Future<void> submitFoodOrder(
    BuildContext context,
    AppProvider appProvider,
    CartProvider cartProvider,
    AddressesProvider addressesProvider, {
    @required int paymentMethodId,
    @required String notes,
    String couponCode,
    @required RestaurantDeliveryType deliveryType,
  }) async {
    if (cartProvider.noFoodCart) {
      print('No current cart!');
      return false;
    }

    if (addressesProvider.selectedAddress == null) {
      print('No address selected!');
      return false;
    }

    if (HomeProvider.selectedFoodBranchId == null || HomeProvider.selectedFoodChainId == null) {
      print('Either chain id (${HomeProvider.selectedFoodChainId}) or restaurant id (${HomeProvider.selectedFoodBranchId}) is null');
      return;
    }

    Map<String, dynamic> body = {
      'branch_id': HomeProvider.selectedFoodBranchId,
      'chain_id': HomeProvider.selectedFoodChainId,
      'cart_id': cartProvider.foodCart.id,
      'payment_method_id': paymentMethodId,
      'selected_address_id': addressesProvider.selectedAddress.id,
      'notes': notes,
      'coupon_redeem_code': couponCode,
      'delivery_type': restaurantDeliveryTypeValues.reverse[deliveryType],
    };

    print('Order submit request body:');
    print(body);

    final endpoint = 'orders';
    try {
      final responseData = await appProvider.post(
        endpoint: endpoint,
        body: body,
        withToken: true,
      );

      submittedFoodOrder = Order.fromJson(responseData["data"]);
      print('Deleting chain id and branch id from local storage...');
      await storageActions.deleteData(key: 'selected_food_branch_id');
      await storageActions.deleteData(key: 'selected_food_chain_id');
      HomeProvider.selectedFoodBranchId = null;
      HomeProvider.selectedFoodChainId = null;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> fetchAndSetMarketPreviousOrders(AppProvider appProvider) async {
    final endpoint = 'orders/grocery';
    final Map<String, String> body = {
      'chain_id': '${HomeProvider.chainId}',
    };

    final responseData = await appProvider.get(
      endpoint: endpoint,
      body: body,
      withToken: true,
    );
    // print(responseData);
    if (responseData == 401) {
      return 401;
    }

    marketPreviousOrders = List<Order>.from(responseData["data"].map((x) => Order.fromJson(x)));
    notifyListeners();
  }

  Future<dynamic> fetchAndSetFoodPreviousOrders(AppProvider appProvider) async {
    final endpoint = 'orders/food';

    final responseData = await appProvider.get(
      endpoint: endpoint,
      withToken: true,
    );
    // print(responseData);
    if (responseData == 401) {
      return 401;
    }

    foodPreviousOrders = List<Order>.from(responseData["data"].map((x) => Order.fromJson(x)));
    notifyListeners();
  }

  Future<dynamic> fetchAndSetPreviousOrder(AppProvider appProvider, int orderId) async {
    final endpoint = 'orders/$orderId';

    final responseData = await appProvider.get(
      endpoint: endpoint,
      withToken: true,
    );
    // print(responseData);
    if (responseData == 401) {
      return 401;
    }

    order = Order.fromJson(responseData["data"]["order"]);
    notifyListeners();
  }

  Future<void> deletePreviousOrder(AppProvider appProvider, int orderId) async {
    isLoadingDeleteOrderRequest = true;
    notifyListeners();

    final endpoint = 'orders/$orderId/delete';
    await appProvider.post(endpoint: endpoint, withToken: true);
    isLoadingDeleteOrderRequest = false;
    notifyListeners();
  }

  Future<void> createOrderRating(AppProvider appProvider, int orderId, {bool isMarketOrder = true}) async {
    final endpoint = 'orders/$orderId/rate';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: true);
    if (responseData == 401) {
      print('Unauthenticated');
      return 401;
    }
    if (isMarketOrder) {
      final availableIssuesArray = responseData["data"]["availableIssues"];
      marketOrderRatingAvailableIssues =
          List<MarketOrderRatingAvailableIssue>.from(availableIssuesArray.map((x) => MarketOrderRatingAvailableIssue.fromJson(x)));
    } else {
      foodOrderRatingFactors = List<FoodOrderRatingFactors>.from(responseData["data"].map((x) => FoodOrderRatingFactors.fromJson(x)));
    }
    notifyListeners();
  }

  Future<void> storeOrderRating(AppProvider appProvider, int orderId, Map<String, dynamic> ratingData) async {
    final endpoint = 'orders/$orderId/rate';
    final responseData = await appProvider.post(endpoint: endpoint, body: ratingData, withToken: true);
    if (responseData == 401) {
      print('Unauthenticated');
      return 401;
    }
    if (responseData["status"] != 200) {
      throw HttpException(title: 'Http Exception Error', message: getHttpExceptionMessage(responseData));
    }
    notifyListeners();
  }

  Future<dynamic> validateMarketCoupon({
    AppProvider appProvider,
    CartProvider cartProvider,
    String couponCode,
  }) async {
    final endpoint = 'coupons/$couponCode/validate';
    Map<String, String> body = {
      'branch_id': '${HomeProvider.branchId}',
      'cart_id': '${cartProvider.marketCart.id}',
    };
    final responseData = await appProvider.get(
      endpoint: endpoint,
      body: body,
      withToken: true,
    );
    if (responseData == 401) {
      return 401;
    }
    couponValidationData = CouponValidationData.fromJson(responseData["data"]);
    notifyListeners();
  }

  Future<dynamic> validateFoodCoupon({
    AppProvider appProvider,
    int cartId,
    int selectedAddressId,
    String couponCode,
    RestaurantDeliveryType deliveryType,
  }) async {
    final endpoint = 'coupons/$couponCode/validate';
    Map<String, String> body = {
      'branch_id': '${HomeProvider.selectedFoodBranchId}',
      'cart_id': '$cartId',
      'delivery_type': restaurantDeliveryTypeValues.reverse[deliveryType],
      'selected_address_id': '$selectedAddressId',
    };
    final responseData = await appProvider.get(
      endpoint: endpoint,
      body: body,
      withToken: true,
    );
    print('food coupon validation responseData');
    print(responseData);

    couponValidationData = CouponValidationData.fromJson(responseData["data"]);
    notifyListeners();
  }
}
