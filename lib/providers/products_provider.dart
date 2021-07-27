import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';

import 'market_provider.dart';

class ProductsProvider with ChangeNotifier {
  Category selectedParentCategory;
  List<Category> marketParentCategories = <Category>[];

  // List<Category> selectedParentChildCategories = [];

  List<Product> searchedProducts = [];
  List<Product> favoriteProducts = [];
  Product product;
  List<ProductOption> productOptions = <ProductOption>[];
  ProductCartData productTempCartData;
  bool isLoadingFetchAllProductsRequest = false;
  bool fetchAllProductsError = false;

  Map<int, Map<int, List<Product>>> products = {}; //i.e. {ParentCategoryId: {ChildCategoryId: List<Product>}}
  Map<int, List<Category>> parentCategoryData = {}; //i.e. {ParentCategoryId: list of child categories with their products}

  Future<void> fetchAndSetParentCategoriesAndProducts() async {
    final endpoint = 'grocery/categories';
    fetchAllProductsError = false;
    isLoadingFetchAllProductsRequest = true;
    notifyListeners();
    try {
      print('Fetching all market products in the background.... 👻');
      final responseData = await AppProvider().get(endpoint: endpoint, body: {
        'branch_id': '${MarketProvider.branchId}',
      });
      marketParentCategories = List<Category>.from(responseData["data"].map((x) => Category.fromJson(x)));
      isLoadingFetchAllProductsRequest = false;
      print('Fetched all market products in the background 👻');
      notifyListeners();
    } catch (e) {
      print('An error occurred while fetching all market products in the background.... 👻');
      fetchAllProductsError = true;
      isLoadingFetchAllProductsRequest = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> fetchAndSetChildCategoriesAndProducts(int selectedParentCategoryId) async {
    final endpoint = 'grocery/categories/$selectedParentCategoryId/products';

    final responseData = await AppProvider().get(endpoint: endpoint, body: {
      'branch_id': '${MarketProvider.branchId}',
    });
    selectedParentCategory = Category.fromJson(responseData["data"]["selectedParent"]);
    List<Category> _selectedParentChildCategories =
        selectedParentCategory.childCategories.where((childCategory) => childCategory.products != null && childCategory.products.length > 0).toList();
    parentCategoryData[selectedParentCategory.id] = _selectedParentChildCategories;
    notifyListeners();
  }

  void setProductTempOption({
    Product product,
    ProductOption option,
    int selectionOrIngredientId,
    BuildContext context,
  }) {
    bool hasDiscountedPrice = product.discountedPrice != null && product.discountedPrice.raw != 0 && product.discountedPrice.raw < product.price.raw;
    double productTotalPrice = hasDiscountedPrice ? product.discountedPrice.raw : product.price.raw;
    print('productTotalPrice');
    print(productTotalPrice);
    List<ProductSelectedOption> newSelectedOptions;
    newSelectedOptions = productTempCartData.selectedOptions.map((selectedProductOption) {
      List<int> selectionIds = selectedProductOption.selectionIds == null ? <int>[] : selectedProductOption.selectionIds;
      //Edit target option
      if (selectedProductOption.productOptionId == option.id) {
        double optionTotalPrice = 0.0;
        List<int> newSelectionIds = <int>[];
        //Update selected selections or ingredients ids
        if (option.selectionType == ProductOptionSelectionType.SINGLE) {
          newSelectionIds = [selectionOrIngredientId];
        } else {
          newSelectionIds = addOrRemoveIdsFromArray(
            array: selectionIds,
            id: selectionOrIngredientId,
            maxLength: option.type == ProductOptionType.EXCLUDING ? null : option.maxNumberOfSelection,
            context: context,
          );
        }

        //Update product total price
        newSelectionIds.forEach((selectedId) {
          List<ProductOptionSelection> selectionsOrIngredients = option.isBasedOnIngredients ? option.ingredients : option.selections;
          selectionsOrIngredients.forEach((selectionOrIngredient) {
            if (selectionOrIngredient.id == selectedId && selectionOrIngredient.price.raw > 0) {
              optionTotalPrice += selectionOrIngredient.price.raw;
            }
          });
        });

        return ProductSelectedOption(
          productOptionId: option.id,
          selectionIds: newSelectionIds == null ? <int>[] : newSelectionIds,
          optionTotalPrice: optionTotalPrice,
        );
      } else {
        //Return non-target option as is
        return selectedProductOption;
      }
    }).toList();
    newSelectedOptions.forEach((selectedProductOption) {
      productTotalPrice += selectedProductOption.optionTotalPrice;
    });
    double newProductTotalPrice = productTotalPrice * productTempCartData.quantity;
    productTempCartData = ProductCartData(
      productId: product.id,
      selectedOptions: newSelectedOptions,
      productTotalPrice: newProductTotalPrice,
      quantity: productTempCartData.quantity,
    );
    print('productsCartData array:');
    print(json.encode(productTempCartData));
    notifyListeners();
  }

  void setProductTempQuantity(CartAction action) {
    bool hasDiscountedPrice = product.discountedPrice != null && product.discountedPrice.raw != 0 && product.discountedPrice.raw < product.price.raw;
    double productTotalPrice = hasDiscountedPrice ? product.discountedPrice.raw : product.price.raw;
    if (action == CartAction.ADD) {
      productTempCartData.quantity++;
    } else {
      if (productTempCartData.quantity > 1) {
        productTempCartData.quantity--;
      } else {
        return;
      }
    }
    productTempCartData.selectedOptions.forEach((selectedProductOption) {
      productTotalPrice += selectedProductOption.optionTotalPrice;
    });
    productTempCartData.productTotalPrice = productTotalPrice * productTempCartData.quantity;
    print('productTempCartData');
    print(productTempCartData.toJson());
    notifyListeners();
  }

  List<Map<String, dynamic>> invalidOptions = [];

  bool validateProductOptions(BuildContext context) {
    bool optionsAreValid = true;
    invalidOptions = [];
    productTempCartData.selectedOptions.forEach((selectedOption) {
      ProductOption targetOptionData = productOptions.firstWhere((option) => option.id == selectedOption.productOptionId, orElse: () => null);
      if (targetOptionData == null) {
        print("target option wasn't found!");
        return false;
      }
      if (targetOptionData.selectionType == ProductOptionSelectionType.SINGLE) {
        if (targetOptionData.isRequired && selectedOption.selectionIds.length == 0) {
          optionsAreValid = false;
          invalidOptions.add({
            'product_option_id': selectedOption.productOptionId,
            'message': Translations.of(context).get("This option is required"),
          });
        }
      } else {
        if (selectedOption.selectionIds.length < targetOptionData.minNumberOfSelection) {
          optionsAreValid = false;
          invalidOptions.add({
            'product_option_id': selectedOption.productOptionId,
            'message': Translations.of(context).get(
              "You have to pick at least {targetOptionMinNumberOfSelection} options",
              args: [targetOptionData.minNumberOfSelection.toString()],
            ),
          });
        }
      }
    });
    print('optionsAreValid : $optionsAreValid');
    print('invalid options : $invalidOptions');
    notifyListeners();
    return optionsAreValid;
  }

  Map<String, dynamic> getOptionValidation(int optionId) {
    return invalidOptions.firstWhere((invalidOption) => invalidOption["product_option_id"] == optionId, orElse: () => null);
  }

  void initProductOptions(CartProduct existingCartProduct) {
    if (existingCartProduct != null) {
      print('existingCartProduct, cart product id: ${existingCartProduct.cartProductId}, selected options:');
      print(List<dynamic>.from(existingCartProduct.selectedOptions.map((x) => x.toJson())));
    }
    bool hasDiscountedPrice = product.discountedPrice != null && product.discountedPrice.raw != 0 && product.discountedPrice.raw < product.price.raw;
    productTempCartData = ProductCartData(
      productId: product.id,
      selectedOptions: productOptions.map((option) {
        ProductSelectedOption _existingSelectedOption = existingCartProduct == null
            ? null
            : existingCartProduct.selectedOptions
                .firstWhere((existingSelectedOption) => existingSelectedOption.productOptionId == option.id, orElse: () => null);
        List<int> _selectionIds = _existingSelectedOption != null ? _existingSelectedOption.selectionIds : <int>[];

        double _optionTotalPrice = 0.0;
        _selectionIds.forEach((selectedId) {
          List<ProductOptionSelection> selectionsOrIngredients = option.isBasedOnIngredients ? option.ingredients : option.selections;
          selectionsOrIngredients.forEach((selectionOrIngredient) {
            if (selectionOrIngredient.id == selectedId && selectionOrIngredient.price.raw > 0) {
              _optionTotalPrice += selectionOrIngredient.price.raw;
            }
          });
        });

        return ProductSelectedOption(
          productOptionId: option.id,
          selectionIds: _selectionIds,
          optionTotalPrice: _optionTotalPrice,
        );
      }).toList(),
      productTotalPrice: existingCartProduct == null
          ? hasDiscountedPrice
              ? product.discountedPrice.raw
              : product.price.raw
          : existingCartProduct.totalPrice.raw,
      quantity: existingCartProduct == null ? 1 : existingCartProduct.quantity,
    );
    invalidOptions = [];
    print('initial productTempCartData:');
    print(json.encode(productTempCartData.toJson()["selectedOptions"]));
  }

  Future<void> fetchSearchedMarketProducts(searchQuery) async {
    final endpoint = 'search/products';
    try {
      final Map<String, String> body = {
        'q': searchQuery,
        'branch_id': MarketProvider.branchId.toString(),
        'chain_id': MarketProvider.chainId.toString(),
      };
      final responseData = await AppProvider().get(endpoint: endpoint, body: body);
      searchedProducts = responseData["data"] == null ? <Product>[] : List<Product>.from(responseData["data"].map((x) => Product.fromJson(x)));
    } catch (e) {
      print('@e Error');
      print(e);
    }
  }

  Future<dynamic> fetchAndSetProduct(
    AppProvider appProvider,
    int productId, {
    CartProduct cartProduct,
  }) async {
    final endpoint = 'products/$productId';
    final responseData = await appProvider.get(endpoint: endpoint, withToken: appProvider.isAuth);
    product = Product.fromJson(responseData["data"]);
    productOptions = product.options.where((option) {
      //Items lengths condition
      bool hasItems = option.selections.length != 0 || option.ingredients.length != 0;
      //valid option properties condition
      bool validIngredientBasedOptionProperties = true;
      if (option.isBasedOnIngredients) {
        validIngredientBasedOptionProperties = option.isBasedOnIngredients && option.inputType == ProductOptionInputType.PILL;
      }
      return hasItems && validIngredientBasedOptionProperties;
    }).toList();
    initProductOptions(cartProduct);
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
