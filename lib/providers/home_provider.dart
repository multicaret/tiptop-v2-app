import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

import 'addresses_provider.dart';
import 'cart_provider.dart';
import 'local_storage.dart';

class HomeProvider with ChangeNotifier {
  HomeDataResponse homeDataResponse;
  HomeData homeData;
  EstimatedArrivalTime estimatedArrivalTime;
  List<Category> categories;
  List<Slide> slides;
  int branchId;
  int chainId;

  bool categorySelected = false;
  int selectedParentCategoryId;

  bool homeDataRequestError = false;
  bool noBranchFound = false;

  static double branchLat;
  static double branchLong;

  LocalStorage storageActions = LocalStorage.getActions();
  bool isLocationPermissionGranted = false;

  Future<void> fetchAndSetHomeData(
    BuildContext context,
    AppProvider appProvider,
    CartProvider cartProvider,
    AddressesProvider addressesProvider,
  ) async {
    final endpoint = 'home';

    if (AppProvider.latitude == null || AppProvider.longitude == null) {
      bool isEnabled = await handleLocationPermission();
      if (!isEnabled) {
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(LocationPermissionPage.routeName);
      }
    }

    final body = {
      'latitude': '${AppProvider.latitude}',
      'longitude': '${AppProvider.longitude}',
      'channel': 'grocery',
      'selected_address_id': addressesProvider.selectedAddress == null ? '' : '${addressesProvider.selectedAddress.id}',
    };

    try {
      final responseData = await appProvider.get(
        endpoint: endpoint,
        body: body,
        withToken: appProvider.isAuth,
      );

      // print(responseData["data"]["cart"]);
      homeDataResponse = homeDataResponseFromJson(json.encode(responseData));

      if (homeDataResponse.homeData == null || homeDataResponse.status != 200) {
        homeDataRequestError = true;
        notifyListeners();
        throw HttpException(title: 'Error', message: homeDataResponse.message);
      }

      homeData = homeDataResponse.homeData;
      categories = homeData.categories;
      slides = homeData.slides;
      estimatedArrivalTime = homeData.estimatedArrivalTime;

      if (homeData.branch == null) {
        noBranchFound = true;
      } else {
        branchId = homeData.branch.id;
        if (homeData.branch.chain != null) {
          chainId = homeData.branch.chain.id;
        }
        branchLat = homeData.branch.latitude;
        branchLong = homeData.branch.longitude;
      }

      if (homeData.cart != null) {
        cartProvider.setCart(homeData.cart);
        print(homeData.cart.id);
      }

      notifyListeners();
    } catch (e) {
      homeDataRequestError = true;
      notifyListeners();
      throw e;
    }
  }
}
