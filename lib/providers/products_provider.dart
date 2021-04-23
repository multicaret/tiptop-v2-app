import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';

class ProductsProvider with ChangeNotifier {
  CategoryParentsData categoryParentsData;
  Category selectedParent;
  List<Category> parents = [];
  List<Category> selectedParentChildCategories = [];
  List<Product> searchedProducts = [];
  List<Product> favoriteProducts = [];
  Product product;
  Map<String, dynamic> productTempCartData = {};

  void setProductTempOption({
    Product product,
    ProductOption option,
    int selectionOrIngredientId,
    BuildContext context,
  }) {
    double productTotalPrice = product.discountedPrice != null && product.discountedPrice.raw == 0 ? product.discountedPrice.raw : product.price.raw;
    List<Map<String, dynamic>> productSelectedOptions = productTempCartData["options"] as List<Map<String, dynamic>>;
    List<Map<String, dynamic>> newSelectedOptions;
    newSelectedOptions = productSelectedOptions.map((Map<String, dynamic> selectedProductOption) {
      List<int> selectedIds = selectedProductOption['selected_ids'] == null ? <int>[] : selectedProductOption['selected_ids'];
      //Edit target option
      if (selectedProductOption["id"] == option.id) {
        double optionTotalPrice = 0.0;
        List<int> newSelectedIds = <int>[];
        //Update selected selections or ingredients ids
        if (option.selectionType == ProductOptionSelectionType.SINGLE) {
          newSelectedIds = [selectionOrIngredientId];
        } else {
          newSelectedIds = addOrRemoveIdsFromArray(
            array: selectedIds,
            id: selectionOrIngredientId,
            maxLength: option.type == ProductOptionType.EXCLUDING ? null : option.maxNumberOfSelection,
            context: context,
          );
        }

        //Update product total price
        newSelectedIds.forEach((selectedId) {
          List<ProductOptionSelection> selectionsOrIngredients = option.isBasedOnIngredients ? option.ingredients : option.selections;
          selectionsOrIngredients.forEach((selectionOrIngredient) {
            if (selectionOrIngredient.id == selectedId && selectionOrIngredient.price.raw > 0) {
              optionTotalPrice += selectionOrIngredient.price.raw;
            }
          });
        });

        return {
          'id': option.id,
          'selected_ids': newSelectedIds,
          'option_total_price': optionTotalPrice,
        };
      } else {
        //Return non-target option as is
        return selectedProductOption;
      }
    }).toList();
    newSelectedOptions.forEach((selectedProductOption) {
      productTotalPrice += selectedProductOption['option_total_price'];
    });
    double newProductTotalPrice = productTotalPrice * productTempCartData['quantity'];
    productTempCartData = {
      'product_id': product.id,
      'options': newSelectedOptions,
      'product_total_price': newProductTotalPrice,
      'quantity': productTempCartData['quantity'],
    };
    print('productsCartData array:');
    print(productTempCartData);
    notifyListeners();
  }

  void setProductTempQuantity(CartAction action) {
    double productTotalPrice = product.discountedPrice != null && product.discountedPrice.raw == 0 ? product.discountedPrice.raw : product.price.raw;
    if (action == CartAction.ADD) {
      productTempCartData['quantity']++;
    } else {
      if (productTempCartData['quantity'] > 1) {
        productTempCartData['quantity']--;
      } else {
        return;
      }
    }
    productTempCartData['options'].forEach((selectedProductOption) {
      productTotalPrice += selectedProductOption['option_total_price'];
    });
    productTempCartData['product_total_price'] = productTotalPrice * productTempCartData['quantity'];
    print('productTempCartData');
    print(productTempCartData);
    notifyListeners();
  }

  void initProductOptions(Product product) {
    productTempCartData = {
      'product_id': product.id,
      'options': product.options.map((option) {
        return {
          'id': option.id,
          'selected_ids': <int>[],
          'option_total_price': 0.0,
        };
      }).toList(),
      'product_total_price': product.discountedPrice != null && product.discountedPrice.raw == 0 ? product.discountedPrice.raw : product.price.raw,
      'quantity': 1,
    };
    print('initial productTempCartData:');
    print(productTempCartData);
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
    initProductOptions(product);
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
