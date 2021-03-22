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
  List<Category> categories;
  List<Slide> slides;
  int branchId;
  int chainId;

  bool categorySelected = false;
  int selectedParentCategoryId;

  LocalStorage storageActions = LocalStorage.getActions();

  Future<void> selectCategory(int categoryId) async {
    selectedParentCategoryId = categoryId;
    categorySelected = categoryId != null;
    await storageActions.save(key: 'selected_category_id', data: selectedParentCategoryId);
    print('selected category saved in provider $categoryId');
    notifyListeners();
  }

  Future<void> fetchAndSetHomeData(AppProvider appProvider, CartProvider cartProvider) async {
    final endpoint = 'home';
    final body = {
      'latitude': '${AppProvider.latitude}',
      'longitude': '${AppProvider.longitude}',
      'channel': 'grocery',
      'selected_address_id': '1',
    };

    final responseData = await appProvider.get(
      endpoint: endpoint,
      body: body,
      withToken: appProvider.isAuth,
    );
    // print(responseData);
    homeDataResponse = homeDataResponseFromJson(json.encode(responseData));

    if (homeDataResponse.homeData == null || homeDataResponse.status != 200) {
      throw HttpException(title: 'Error', message: homeDataResponse.message);
    }

    homeData = homeDataResponse.homeData;
    categories = homeData.categories;
    slides = homeData.slides;
    branchId = homeData.branch == null ? null : homeData.branch.id;
    chainId = branchId == null
        ? null
        : homeData.branch.chain == null
            ? null
            : homeData.branch.chain.id;

    if (homeData.cart != null) {
      cartProvider.setCart(homeData.cart);
    }

    notifyListeners();
  }
}
