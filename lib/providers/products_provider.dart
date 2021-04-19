import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';

class ProductsProvider with ChangeNotifier {
  CategoryParentsData categoryParentsData;
  Category selectedParent;
  List<Category> parents = [];
  List<Category> selectedParentChildCategories = [];
  List<Product> searchedProducts = [];
  List<Product> favoriteProducts = [];
  Product product;
  List<Map<String, dynamic>> productsWithOptions = [];

  Map<String, dynamic> getProductWithOptions(int productId) {
    return productsWithOptions.firstWhere((productWithOptions) => productWithOptions["product_id"] == productId, orElse: () => null);
  }

  void setProductSelectedOption(int productId, Map<String, dynamic> optionData) {
    productsWithOptions = productsWithOptions.map((productWithOptions) {
      if (productWithOptions["product_id"] == productId) {
        List<Map<String, dynamic>> productSelectedOptions = productWithOptions["selected_options"] as List<Map<String, dynamic>>;
        List<Map<String, dynamic>> newSelectedOptions;
        if (productSelectedOptions.length == 0) {
          newSelectedOptions = [optionData];
        } else {
          newSelectedOptions = productSelectedOptions
              .map((Map<String, dynamic> selectedOption) => selectedOption["id"] == optionData["id"] ? optionData : selectedOption)
              .toList();
        }
        return {
          'product_id': productId,
          'selected_options': newSelectedOptions,
        };
      } else {
        return productWithOptions;
      }
    }).toList();
    print('productsWithOptions array:');
    print(productsWithOptions);
    notifyListeners();
  }

  Future<void> fetchAndSetParentsAndProducts(int selectedParentCategoryId) async {
    final endpoint = 'categories/$selectedParentCategoryId/products';

    final responseData = await AppProvider().get(endpoint: endpoint);

    categoryParentsData = CategoryParentsData.fromJson(responseData["data"]);
    parents = categoryParentsData.parentCategories;
    selectedParent = categoryParentsData.selectedParentCategory;
    selectedParentChildCategories = selectedParent.childCategories;
  }

  Future<void> fetchSearchedProducts(searchQuery) async {
    final endpoint = 'search/products';
    try {
      final Map<String, String> body = {
        'q': searchQuery,
        'branch_id': HomeProvider.branchId.toString(),
        'chain_id': HomeProvider.chainId.toString(),
      };
      final responseData = await AppProvider().get(endpoint: endpoint, body: body);
      searchedProducts = responseData["data"] == null ? <Product>[] : List<Product>.from(responseData["data"].map((x) => Product.fromJson(x)));
    } catch (e) {
      print('@e Error');
      print(e);
    }
  }

  Future<dynamic> fetchAndSetProduct(AppProvider appProvider, int productId) async {
    final endpoint = 'products/$productId';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: appProvider.isAuth);
    product = Product.fromJson(responseData["data"]);
    if (getProductWithOptions(product.id) == null) {
      List<Map<String, dynamic>> selectedOptions = product.options.map((option) {
        List<ProductOptionSelection> ingredientOrSelection = option.isBasedOnIngredients ? option.ingredients : option.selections;
        List<int> selectedIds = ingredientOrSelection.map((ingredientOrSelection) => ingredientOrSelection.id).toList();
        return {
          'id': option.id,
          'selected_ids': option.isRequired
              ? option.selectionType == ProductOptionSelectionType.SINGLE
                  ? [selectedIds[0]]
                  : selectedIds
              : <int>[],
        };
      }).toList();
      productsWithOptions = [
        ...productsWithOptions,
        {
          'product_id': product.id,
          'selected_options': selectedOptions,
        },
      ];
    }
    print('productsWithOptions on fetching product:');
    print(productsWithOptions);
    notifyListeners();
  }

  Future<dynamic> interactWithProduct(AppProvider appProvider, int productId, Interaction interaction) async {
    final endpoint = 'products/$productId/interact';
    final body = {
      "action": interactionValues.reverse[interaction],
    };
    print(body);
    print('productId $productId');
    print('action: ${interactionValues.reverse[interaction]}');
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
    notifyListeners();
  }

  Future<dynamic> fetchAndSetFavoriteProducts(AppProvider appProvider) async {
    final endpoint = 'profile/favorites';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: true);
    if (responseData == 401) {
      print('Unauthenticated!');
      return 401;
    }
    favoriteProducts = List<Product>.from(responseData["data"]["products"].map((x) => Product.fromJson(x)));
    notifyListeners();
  }
}
