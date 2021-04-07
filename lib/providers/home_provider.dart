import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

import 'addresses_provider.dart';
import 'cart_provider.dart';
import 'local_storage.dart';

class HomeProvider with ChangeNotifier {
  HomeData marketHomeData;
  HomeData foodHomeData;

  static int branchId;
  static int chainId;

  bool categorySelected = false;
  int selectedParentCategoryId;

  bool homeDataRequestError = false;
  bool marketNoBranchFound = false;
  bool foodNoBranchFound = false;

  static double marketBranchLat;
  static double marketBranchLong;

  LocalStorage storageActions = LocalStorage.getActions();
  bool isLocationPermissionGranted = false;

  String selectedChannel = 'grocery';

  void setSelectedChannel(String _channel) {
    selectedChannel = _channel;
    print('Selected channel: $selectedChannel');
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
    CartProvider cartProvider,
    AddressesProvider addressesProvider,
  ) async {
    final endpoint = 'home';

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

    homeDataRequestError = false;
    marketNoBranchFound = false;
    foodNoBranchFound = false;
    // try {
      final responseData = await appProvider.get(
        endpoint: endpoint,
        body: body,
        withToken: appProvider.isAuth,
      );

      if (responseData["data"] == null || responseData["status"] != 200) {
        homeDataRequestError = true;
        notifyListeners();
        throw HttpException(title: 'Http Exception Error', message: getHttpExceptionMessage(responseData));
      }
      setHomeData(cartProvider, responseData["data"]);
      notifyListeners();
/*    } catch (e) {
      homeDataRequestError = true;
      notifyListeners();
      throw e;
    }*/
  }

  void setHomeData(CartProvider cartProvider, data) {
    if (selectedChannel == 'grocery') {
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

      if (marketHomeData.cart != null) {
        cartProvider.setMarketCart(marketHomeData.cart);
      }
    } else {
      foodHomeData = HomeData.fromJson(data);
      if (foodHomeData.branch == null) {
        foodNoBranchFound = true;
      } else {
        branchId = foodHomeData.branch.id;
        if (foodHomeData.branch.chain != null) {
          chainId = foodHomeData.branch.chain.id;
        }
      }

      if (foodHomeData.cart != null) {
        // cartProvider.setFoodCart(foodHomeData.cart);
      }
    }
  }
}
