import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

import 'addresses_provider.dart';
import 'cart_provider.dart';
import 'local_storage.dart';

class MarketProvider with ChangeNotifier {
  HomeData marketHomeData;
  List<Category> marketParentCategoriesWithoutChildren = <Category>[];
  Currency marketCurrency;

  static int branchId;
  static int chainId;

  bool categorySelected = false;
  int selectedParentCategoryId;

  bool isLoadingMarketHomeData = false;

  bool marketHomeDataRequestError = false;
  bool marketNoBranchFound = false;
  String marketNoAvailabilityMessage = '';

  static double marketBranchLat;
  static double marketBranchLong;

  LocalStorage storageActions = LocalStorage.getActions();
  bool isLocationPermissionGranted = false;

  Future<void> fetchAndSetMarketHomeData({
    BuildContext context,
    AppProvider appProvider,
    CartProvider cartProvider,
  }) async {
    final endpoint = 'home';
    isLoadingMarketHomeData = true;
    notifyListeners();

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
      'channel': appChannelValues.reverse[AppChannel.MARKET],
      'selected_address_id': AddressesProvider.selectedAddressId == null ? '' : '${AddressesProvider.selectedAddressId}',
      'use_mini_order': '',
    };

    marketHomeDataRequestError = false;
    marketNoBranchFound = false;
    try {
      final responseData = await appProvider.get(
        endpoint: endpoint,
        body: body,
        withToken: appProvider.isAuth,
      );
      // print('responseData of market home request');
      // print(responseData);
      print('Setting market home data...');
      marketHomeData = HomeData.fromJson(responseData["data"]);
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

      marketParentCategoriesWithoutChildren = marketHomeData.categories;
      if (marketHomeData.cart != null) {
        cartProvider.setMarketCart(marketHomeData.cart);
      }
      print('Notifying listeners from market provider fetch market home data function!');
      isLoadingMarketHomeData = false;
      notifyListeners();
    } catch (e) {
      print('An error happened in market home data request');
      marketHomeDataRequestError = true;
      isLoadingMarketHomeData = false;
      notifyListeners();
      throw e;
    }
  }
}
