import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

import 'addresses_provider.dart';
import 'cart_provider.dart';
import 'local_storage.dart';

class HomeProvider with ChangeNotifier {
  HomeData marketHomeData;
  List<Category> marketParentCategories = [];
  Currency marketCurrency;

  HomeData foodHomeData;
  Currency foodCurrency;

  static int branchId;
  static int chainId;
  static int selectedFoodBranchId;
  static int selectedFoodChainId;

  bool categorySelected = false;
  int selectedParentCategoryId;

  bool isLoadingHomeData = false;

  bool marketHomeDataRequestError = false;
  bool marketNoBranchFound = false;
  String marketNoAvailabilityMessage = '';

  bool foodNoRestaurantFound = false;
  bool foodHomeDataRequestError = false;
  String foodNoAvailabilityMessage = '';

  static double marketBranchLat;
  static double marketBranchLong;

  LocalStorage storageActions = LocalStorage.getActions();
  bool isLocationPermissionGranted = false;

  AppChannel selectedChannel = AppProvider.appDefaultChannel;

  bool get channelIsMarket => selectedChannel == AppChannel.MARKET;

  void fetchSelectedFoodBranchAndChainIds() {
    selectedFoodBranchId = storageActions.getData(key: 'selected_food_branch_id');
    selectedFoodChainId = storageActions.getData(key: 'selected_food_chain_id');
  }

  void setSelectedChannel(AppChannel _channel) {
    selectedChannel = _channel;
    print('Selected channel: $selectedChannel');
    notifyListeners();
  }

  EstimatedArrivalTime getEstimateArrivalTime() {
    if (channelIsMarket) {
      return marketHomeData == null ? null : marketHomeData.estimatedArrivalTime;
    } else {
      return foodHomeData == null ? null : foodHomeData.estimatedArrivalTime;
    }
  }

  Future<void> fetchAndSetHomeData(
    BuildContext context,
    AppProvider appProvider, {
    bool afterLanguageChange = false,
  }) async {
    final endpoint = 'home';
    isLoadingHomeData = true;
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

    final body = {
      'latitude': '${AppProvider.latitude}',
      'longitude': '${AppProvider.longitude}',
      'channel': appChannelValues.reverse[selectedChannel],
      'selected_address_id': AddressesProvider.selectedAddressId == null ? '' : '${AddressesProvider.selectedAddressId}',
    };

    if (!channelIsMarket) {
      fetchSelectedFoodBranchAndChainIds();
      body.addAll({
        'selected_food_branch_id': selectedFoodBranchId == null ? null : '$selectedFoodBranchId',
        'selected_food_chain_id': selectedFoodChainId == null ? null : '$selectedFoodChainId',
      });
    }

    marketHomeDataRequestError = false;
    foodHomeDataRequestError = false;
    marketNoBranchFound = false;
    foodNoRestaurantFound = false;
    try {
      final responseData = await appProvider.get(
        endpoint: endpoint,
        body: body,
        withToken: appProvider.isAuth,
      );
      setHomeData(
        cartProvider,
        restaurantsProvider,
        responseData["data"],
      );
      print('Notifying listeners from home provider fetch home data function!');
      isLoadingHomeData = false;
      notifyListeners();
    } catch (e) {
      if (channelIsMarket) {
        print('An error happened in market home data request');
        marketHomeDataRequestError = true;
        isLoadingHomeData = false;
      } else {
        print('An error happened in food home data request');
        foodHomeDataRequestError = true;
        isLoadingHomeData = false;
      }
      notifyListeners();
      throw e;
    }
  }

  void setHomeData(
    CartProvider cartProvider,
    RestaurantsProvider restaurantsProvider,
    data,
  ) {
    if (channelIsMarket) {
      print('Setting market home data...');
      marketHomeData = HomeData.fromJson(data);
      marketCurrency = marketHomeData.currentCurrency;
      if (marketHomeData.branch == null) {
        marketNoBranchFound = true;
        marketNoAvailabilityMessage =
            marketHomeData != null && marketHomeData.noAvailabilityMessage != null ? marketHomeData.noAvailabilityMessage : '';
        print('marketNoAvailabilityMessage');
        print(marketNoAvailabilityMessage);
      } else {
        branchId = marketHomeData.branch.id;
        if (marketHomeData.branch.chain != null) {
          chainId = marketHomeData.branch.chain.id;
        }
        marketBranchLat = marketHomeData.branch.latitude;
        marketBranchLong = marketHomeData.branch.longitude;
      }

      marketParentCategories = marketHomeData.categories;
      if (marketHomeData.cart != null) {
        cartProvider.setMarketCart(marketHomeData.cart);
      }
    } else {
      print('Setting food home data...');
      foodHomeData = HomeData.fromJson(data);
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
    }
  }
}
