import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  ProductsWithCategoriesDataResponse productsWithCategoriesDataResponse;
  ProductsResponse searchedProductsDataResponse;
  CategoryParentsData categoryParentsData;
  Category selectedParent;
  List<Category> parents = [];
  List<Category> selectedParentChildCategories = [];
  List<Product> searchedProducts = [];
  List<Product> favoriteProducts = [];
  Product product;

  Future<void> fetchAndSetParentsAndProducts(int selectedParentCategoryId) async {
    final endpoint = 'categories/$selectedParentCategoryId/products';

    final responseData = await AppProvider().get(endpoint: endpoint);
    productsWithCategoriesDataResponse = productDataResponseFromJson(json.encode(responseData));

    if (productsWithCategoriesDataResponse.categoryParentsData == null || productsWithCategoriesDataResponse.status != 200) {
      throw HttpException(title: 'Error', message: productsWithCategoriesDataResponse.message);
    }

    categoryParentsData = productsWithCategoriesDataResponse.categoryParentsData;
    parents = categoryParentsData.parentCategories;
    selectedParent = categoryParentsData.selectedParentCategory;
    selectedParentChildCategories = selectedParent.childCategories;
  }

  Future<void> fetchSearchedProducts(searchQuery, {HomeProvider homeProvider}) async {
    final endpoint = 'search/products';
    try {
      final Map<String, String> body = {
        'q': searchQuery,
        'branch_id': homeProvider.branchId.toString(),
        'chain_id': homeProvider.chainId.toString(),
      };
      final responseData = await AppProvider().get(endpoint: endpoint, body: body);
      searchedProductsDataResponse = ProductsResponse.fromJson(responseData);
      searchedProducts = searchedProductsDataResponse.data == null ? [] : searchedProductsDataResponse.data;
      if (searchedProductsDataResponse.status != 200) {
        throw HttpException(title: 'Error', message: searchedProductsDataResponse.message);
      }
    } catch (e) {
      print('@e Error');
      print(e);
    }
  }

  Future<dynamic> fetchAndSetProduct(AppProvider appProvider, int productId) async {
    final endpoint = 'products/$productId';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: appProvider.isAuth);
    //Todo: Add (|| responseData["status"] != 200)
    if (responseData["data"] == null) {
      throw HttpException(title: 'Error', message: responseData["message"] ?? 'No Data!');
    }
    product = Product.fromJson(responseData["data"]);
    notifyListeners();
  }

  Future<dynamic> interactWithProduct(AppProvider appProvider, int productId, String action) async {
    final endpoint = 'products/$productId/interact';
    final body = {
      "action": action,
    };
    print(body);
    print('productId $productId');
    print('action: $action');
    final responseData = await appProvider.post(
      endpoint: endpoint,
      body: body,
      withToken: true,
    );
    print(responseData);
    if (responseData == 401) {
      print('Unauthenticated!');
      return 401;
    }
    if (responseData["status"] != 200) {
      throw HttpException(title: 'Error', message: responseData["message"] ?? 'Unknown');
    }
    notifyListeners();
  }

  Future<void> fetchAndSetFavoriteProducts(AppProvider appProvider) async {
    final endpoint = 'profile/favorites';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: true);
    if(responseData["data"] == null || responseData["status"] != 200) {
      throw HttpException(title: 'Error', message: responseData["message"] ?? 'Unknown');
    }
    favoriteProducts = List<Product>.from(responseData["data"]["products"].map((x) => Product.fromJson(x)));
    notifyListeners();
  }
}
