import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

import 'addresses_provider.dart';
import 'cart_provider.dart';
import 'local_storage.dart';

class HomeProvider with ChangeNotifier {
  HomeData marketHomeData;
  List<Category> marketCategories = [];
  HomeData foodHomeData;

  static int branchId;
  static int chainId;

  bool categorySelected = false;
  int selectedParentCategoryId;

  bool isLoadingHomeData = false;

  bool marketHomeDataRequestError = false;
  bool foodHomeDataRequestError = false;
  bool marketNoBranchFound = false;
  bool foodNoRestaurantFound = false;

  static double marketBranchLat;
  static double marketBranchLong;

  LocalStorage storageActions = LocalStorage.getActions();
  bool isLocationPermissionGranted = false;

  String selectedChannel = 'food';

  bool get channelIsMarket => selectedChannel == 'grocery';

  void setSelectedChannel(String _channel) {
    selectedChannel = _channel;
    print('Selected channel: $selectedChannel');
    notifyListeners();
  }

  void setIsLoadingHomeData(bool _value) {
    isLoadingHomeData = _value;
    notifyListeners();
  }

  EstimatedArrivalTime getEstimateArrivalTime() {
    if (selectedChannel == 'grocery') {
      return marketHomeData == null ? null : marketHomeData.estimatedArrivalTime;
    } else {
      return foodHomeData == null ? null : foodHomeData.estimatedArrivalTime;
    }
  }

  Future<void> fetchAndSetHomeData(
    BuildContext context,
    AppProvider appProvider,
  ) async {
    final endpoint = 'home';
    isLoadingHomeData = true;
    notifyListeners();
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    AddressesProvider addressesProvider = Provider.of<AddressesProvider>(context, listen: false);
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
      'channel': selectedChannel,
      'selected_address_id': addressesProvider.selectedAddress == null ? '' : '${addressesProvider.selectedAddress.id}',
    };

    marketHomeDataRequestError = false;
    foodHomeDataRequestError = false;
    marketNoBranchFound = false;
    foodNoRestaurantFound = false;
    try {
      await addressesProvider.fetchSelectedAddress();
      final responseData = await appProvider.get(
        endpoint: endpoint,
        body: body,
        withToken: appProvider.isAuth,
      );

      setHomeData(cartProvider, restaurantsProvider, responseData["data"]);
      isLoadingHomeData = false;
      notifyListeners();
    } catch (e) {
      if (selectedChannel == 'grocery') {
        print('An error happened in market home data request');
        marketHomeDataRequestError = true;
        // throw e;
      } else {
        print('An error happened in food home data request');
        foodHomeDataRequestError = true;
        // throw e;
      }
      isLoadingHomeData = false;
      notifyListeners();
    }
  }

  void setHomeData(CartProvider cartProvider, RestaurantsProvider restaurantsProvider, data) {
    if (selectedChannel == 'grocery') {
      print('Setting market home data...');
      marketHomeData = HomeData.fromJson(data);
      if (marketHomeData.branch == null) {
        marketNoBranchFound = true;
      } else {
        branchId = marketHomeData.branch.id;
        if (marketHomeData.branch.chain != null) {
          chainId = marketHomeData.branch.chain.id;
        }
        marketBranchLat = marketHomeData.branch.latitude;
        marketBranchLong = marketHomeData.branch.longitude;
      }

      final _marketCategories = marketHomeData.categories;
      marketCategories = _marketCategories.where((parentCategory) {
        bool atLeastOneChildHasProducts = false;
        if (parentCategory.hasChildren) {
          final childCategories = parentCategory.childCategories;
          childCategories.forEach((child) {
            if (child.products.length > 0) {
              atLeastOneChildHasProducts = true;
              return;
            }
          });
        }
        return parentCategory.hasChildren && atLeastOneChildHasProducts;
      }).toList();

      if (marketHomeData.cart != null) {
        cartProvider.setMarketCart(marketHomeData.cart);
      }
    } else {
      print('Setting food home data...');
      foodHomeData = HomeData.fromJson(data);
      if (foodHomeData.restaurants.length == 0) {
        foodNoRestaurantFound = true;
      } else {
        restaurantsProvider.setRestaurantData(foodHomeData);
      }

      if (foodHomeData.cart != null) {
        cartProvider.setFoodCart(foodHomeData.cart);
      }
    }
  }
}
