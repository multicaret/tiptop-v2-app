import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  ProductsWithCategoriesDataResponse productsWithCategoriesDataResponse;
  ProductsResponse searchedProductsDataResponse;
  CategoryParentsData categoryParentsData;
  Category selectedParent;
  List<Category> parents = [];
  List<Category> selectedParentChildCategories = [];
  List<Product> searchedProducts = [];

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

  Future<void> fetchSearchedProducts(searchQuery) async {
    final endpoint = 'search/products?q=$searchQuery';

    try {
      final responseData = await AppProvider().get(endpoint: endpoint);
      searchedProductsDataResponse = ProductsResponse.fromJson(responseData);
      searchedProducts = searchedProductsDataResponse.data;

      if (searchedProductsDataResponse.data == null || searchedProductsDataResponse.status != 200) {
        throw HttpException(title: 'Error', message: searchedProductsDataResponse.message);
      }
    } catch (e) {
      print('@e Error');
      print(e);
    }

    // searchedProductsResponse = productDataResponseFromJson(json.encode(responseData));

    // if (searchedProductsResponse == null || productsDataResponse.status != 200) {
    //   throw HttpException(title: 'Error', message: productsDataResponse.message);
    // }
    //
    // searchedProducts =
  }
}
