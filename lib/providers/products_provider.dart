import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  ProductsDataResponse productsDataResponse;
  ParentsData parentsData;
  List<Category> parents = [];
  List<Category> selectedParentSubCategories = [];

  Future<void> fetchAndSetParentsAndProducts(int selectedCategoryId) async {
    final endpoint = 'categories/$selectedCategoryId/products';

    final responseData = await AppProvider().get(endpoint: endpoint);
    productsDataResponse = productDataResponseFromJson(json.encode(responseData));

    if (productsDataResponse.parentsData == null || productsDataResponse.status != 200) {
      throw HttpException(title: 'Error', message: productsDataResponse.message);
    }

    parentsData = productsDataResponse.parentsData;
    parents = parentsData.parents;
    selectedParentSubCategories = parentsData.selectedParent.subCategories;
  }
}
