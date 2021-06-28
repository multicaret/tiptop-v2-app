import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

import 'addresses_provider.dart';
import 'cart_provider.dart';
import 'local_storage.dart';

class FoodProvider with ChangeNotifier {
  HomeData foodHomeData;
  Currency foodCurrency;

  static int selectedFoodBranchId;
  static int selectedFoodChainId;

  bool isLoadingFoodHomeData = false;

  bool foodNoRestaurantFound = false;
  bool foodHomeDataRequestError = false;
  String foodNoAvailabilityMessage = '';

  LocalStorage storageActions = LocalStorage.getActions();
  bool isLocationPermissionGranted = false;

  void fetchSelectedFoodBranchAndChainIds() {
    selectedFoodBranchId = storageActions.getData(key: 'selected_food_branch_id');
    selectedFoodChainId = storageActions.getData(key: 'selected_food_chain_id');
  }

  Future<void> fetchAndSetFoodHomeData(
    BuildContext context,
    AppProvider appProvider, {
    bool afterLanguageChange = false,
  }) async {
    final endpoint = 'home';
    isLoadingFoodHomeData = true;
    notifyListeners();
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    RestaurantsProvider restaurantsProvider = Provider.of<RestaurantsProvider>(context, listen: false);

    if (AppProvider.latitude == null || AppProvider.longitude == null) {
      print('Lat/Long not found!');
      bool isGranted = await getLocationPermissionStatus();
      if (!isGranted) {
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(LocationPermissionPage.routeName);
      } else {
        await updateLocationAndStoreIt();
      }
    }

    fetchSelectedFoodBranchAndChainIds();
    final body = {
      'latitude': '${AppProvider.latitude}',
      'longitude': '${AppProvider.longitude}',
      'channel': appChannelValues.reverse[AppChannel.FOOD],
      'selected_address_id': AddressesProvider.selectedAddressId == null ? '' : '${AddressesProvider.selectedAddressId}',
      'selected_food_branch_id': selectedFoodBranchId == null ? null : '$selectedFoodBranchId',
      'selected_food_chain_id': selectedFoodChainId == null ? null : '$selectedFoodChainId',
      'autoscroll_for_food_branches': '',
      'use_mini_order': '',
    };

    foodHomeDataRequestError = false;
    foodNoRestaurantFound = false;
    try {
      final responseData = await appProvider.get(
        endpoint: endpoint,
        body: body,
        withToken: appProvider.isAuth,
      );

      print('Setting food home data...');
      foodHomeData = HomeData.fromJson(responseData["data"]);
      foodCurrency = foodHomeData.currentCurrency;
      if (foodHomeData.restaurants.length == 0) {
        foodNoRestaurantFound = true;
        foodNoAvailabilityMessage = foodHomeData != null && foodHomeData.noAvailabilityMessage != null ? foodHomeData.noAvailabilityMessage : '';
      } else {
        restaurantsProvider.setRestaurantData(foodHomeData);
      }

      if (foodHomeData.cart != null) {
        cartProvider.setFoodCart(foodHomeData.cart);
      }

      print('Notifying listeners from food provider fetch food home data function!');
      isLoadingFoodHomeData = false;
      notifyListeners();
    } catch (e) {
      print('An error happened in food home data request');
      foodHomeDataRequestError = true;
      isLoadingFoodHomeData = false;
      notifyListeners();
      throw e;
    }
  }
}
