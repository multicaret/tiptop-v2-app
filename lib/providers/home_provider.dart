import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

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

  LocalStorage storageActions = LocalStorage.getActions();

  Future<void> fetchAndSetHomeData(AppProvider appProvider, CartProvider cartProvider) async {
    final endpoint = 'home';
    final body = {
      'latitude': '${AppProvider.latitude}',
      'longitude': '${AppProvider.longitude}',
      'channel': 'grocery',
      //Todo: send dynamically
      'selected_address_id': '1',
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
      }

      branchId = homeData.branch == null ? null : homeData.branch.id;
      chainId = branchId == null
          ? null
          : homeData.branch.chain == null
              ? null
              : homeData.branch.chain.id;

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
