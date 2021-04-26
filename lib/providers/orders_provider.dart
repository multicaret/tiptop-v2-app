import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

import 'app_provider.dart';
import 'cart_provider.dart';
import 'home_provider.dart';

class OrdersProvider with ChangeNotifier {
  SubmitOrderResponse submitOrderResponse;
  Order submittedOrder;
  PreviousOrdersResponseData previousOrdersResponseData;
  List<Order> marketPreviousOrders = [];
  List<Order> foodPreviousOrders = [];

  CheckoutData checkoutData;
  bool isLoadingDeleteOrderRequest = false;
  CouponValidationResponseData couponValidationResponseData;

  List<MarketOrderRatingAvailableIssue> marketOrderRatingAvailableIssues = [];
  List<FoodOrderRatingFactors> foodOrderRatingFactors = [];

  Future<dynamic> createMarketOrderAndGetCheckoutData(AppProvider appProvider) async {
    final endpoint = 'orders/create';
    Map<String, String> body = {
      'chain_id': '${HomeProvider.chainId}',
      'branch_id': '${HomeProvider.branchId}',
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

  Future<dynamic> createFoodOrderAndGetCheckoutData(AppProvider appProvider) async {
    final endpoint = 'orders/create';
    if (HomeProvider.selectedFoodBranchId == null || HomeProvider.selectedFoodChainId == null) {
      print('Either chain id (${HomeProvider.selectedFoodChainId}) or restaurant id (${HomeProvider.selectedFoodBranchId}) is null');
      return;
    }

    Map<String, String> body = {
      'chain_id': '${HomeProvider.selectedFoodChainId}',
      'branch_id': '${HomeProvider.selectedFoodBranchId}',
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
    print(checkoutData.toJson());
    notifyListeners();
  }


  Future<void> submitOrder(
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
      'address_id': addressesProvider.selectedAddress.id,
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

    submitOrderResponse = SubmitOrderResponse.fromJson(responseData);
    if (submitOrderResponse.submittedOrder == null || submitOrderResponse.status != 200) {
      throw HttpException(
          title: 'Http Exception Error', message: submitOrderResponse.message + responseData["file"] ?? "" + responseData["trace"] ?? "");
    }

    submittedOrder = submitOrderResponse.submittedOrder;
    notifyListeners();
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

    previousOrdersResponseData = PreviousOrdersResponseData.fromJson(responseData);

    if (previousOrdersResponseData.previousOrders == null || previousOrdersResponseData.status != 200) {
      throw HttpException(title: 'Http Exception Error', message: previousOrdersResponseData.message ?? 'Unknown');
    }

    marketPreviousOrders = previousOrdersResponseData.previousOrders;
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

    previousOrdersResponseData = PreviousOrdersResponseData.fromJson(responseData);

    if (previousOrdersResponseData.previousOrders == null || previousOrdersResponseData.status != 200) {
      throw HttpException(title: 'Http Exception Error', message: previousOrdersResponseData.message ?? 'Unknown');
    }

    foodPreviousOrders = previousOrdersResponseData.previousOrders;
    notifyListeners();
  }

  Future<void> deletePreviousOrder(AppProvider appProvider, int orderId) async {
    isLoadingDeleteOrderRequest = true;
    notifyListeners();

    final endpoint = 'orders/$orderId/delete';
    final responseData = await appProvider.post(endpoint: endpoint, withToken: true);

    if (responseData["status"] != 200) {
      throw HttpException(title: 'Http Exception Error', message: getHttpExceptionMessage(responseData));
    }
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
      foodOrderRatingFactors =
          List<FoodOrderRatingFactors>.from(responseData["data"].map((x) => FoodOrderRatingFactors.fromJson(x)));
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
    await fetchAndSetMarketPreviousOrders(appProvider);
    notifyListeners();
  }

  Future<dynamic> validateCoupon({
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
    couponValidationResponseData = CouponValidationResponseData.fromJson(responseData["data"]);
    notifyListeners();
  }
}
