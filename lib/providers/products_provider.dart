import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  ProductsDataResponse productsDataResponse;
  ParentsData parentsData;
  Category selectedParent;
  List<Category> parents = [];
  List<Category> selectedParentChildCategories = [];

  Future<void> fetchAndSetParentsAndProducts(int selectedParentCategoryId) async {
    final endpoint = 'categories/$selectedParentCategoryId/products';

    final responseData = await AppProvider().get(endpoint: endpoint);
    productsDataResponse = productDataResponseFromJson(json.encode(responseData));

    if (productsDataResponse.parentsData == null || productsDataResponse.status != 200) {
      throw HttpException(title: 'Error', message: productsDataResponse.message);
    }

    parentsData = productsDataResponse.parentsData;
    parents = parentsData.parents;
    selectedParent = parentsData.selectedParent;
    selectedParentChildCategories = selectedParent.childCategories;
  }
}
