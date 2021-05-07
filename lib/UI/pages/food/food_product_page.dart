import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/pages/profile/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/food/food_cart_controls.dart';
import 'package:tiptop_v2/UI/widgets/food/products/food_product_options.dart';
import 'package:tiptop_v2/UI/widgets/formatted_prices.dart';
import 'package:tiptop_v2/UI/widgets/total_button.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../../widgets/UI/app_scaffold.dart';

class FoodProductPage extends StatefulWidget {
  static const routeName = '/food-product';

  @override
  _FoodProductPageState createState() => _FoodProductPageState();
}

class _FoodProductPageState extends State<FoodProductPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  AutoScrollController productOptionsScrollController;

  bool _isInit = true;
  bool _isLoadingProduct = false;

  ProductsProvider productsProvider;
  CartProvider cartProvider;
  AppProvider appProvider;
  int chainId;
  int restaurantId;
  int productId;
  CartProduct cartProduct;
  Product product;

  String categoryEnglishTitle;
  String restaurantEnglishTitle;

  bool hasDiscountedPrice = false;
  bool hasControls = true;

  List<Map<String, dynamic>> selectedProductOptions = [];
  double productTotalPrice = 0.0;

  Future<void> _fetchAndSetProduct() async {
    setState(() => _isLoadingProduct = true);
    await productsProvider.fetchAndSetProduct(
      appProvider,
      productId,
      cartProduct: cartProduct,
    );
    product = productsProvider.product;
    productTotalPrice = productsProvider.productTempCartData.productTotalPrice;
    hasDiscountedPrice = product.discountedPrice != null && product.discountedPrice.raw != 0 && product.discountedPrice.raw < product.price.raw;
    setState(() => _isLoadingProduct = false);
  }

  Future<void> submitProductCartData(BuildContext context, AppProvider appProvider, AddressesProvider addressesProvider) async {
    if (!appProvider.isAuth) {
      showToast(msg: Translations.of(context).get("You Need to Log In First!"));
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
      return;
    }
    if (!addressesProvider.addressIsSelected) {
      showToast(msg: Translations.of(context).get("You Need to Select Address First!"));
      Navigator.of(context, rootNavigator: true).pushNamed(
        AddressesPage.routeName,
        arguments: {'should_pop_after_selection': true},
      );
      return;
    }
    bool optionsAreValid = productsProvider.validateProductOptions(context);
    if (!optionsAreValid) {
      int firstInvalidOptionIndex =
          productsProvider.productOptions.indexWhere((option) => option.id == productsProvider.invalidOptions[0]['product_option_id']);
      print('firstInvalidOptionIndex: $firstInvalidOptionIndex, product option id: ${productsProvider.invalidOptions[0]['product_option_id']}');
      if (firstInvalidOptionIndex != null) {
        productOptionsScrollController.scrollToIndex(
          firstInvalidOptionIndex,
          preferPosition: AutoScrollPosition.begin,
        );
      }
      showToast(
        msg: "Invalid options! Please check the error messages and modify your options accordingly",
        timeInSec: 3,
      );
      return;
    }
    if (chainId == null || restaurantId == null) {
      print('Either chain id ($chainId) or restaurant id ($restaurantId) is null');
      return;
    }
    bool shouldDeleteExistingCart = false;

    if (cartProvider.foodCart.restaurant != null &&
        (cartProvider.foodCart.restaurant.id != restaurantId || cartProvider.foodCart.restaurant.chain.id != chainId)) {
      print('Adding to cart from a different restaurant');
      final response = await showDialog(
        context: context,
        builder: (context) => ConfirmAlertDialog(
          title: 'This will delete the products in the cart you already have in another restaurant. Are you sure you want to proceed?',
        ),
      );
      if (response != null && response) {
        shouldDeleteExistingCart = true;
      } else {
        return;
      }
    }

    await cartProvider.adjustFoodProductCart(
      context,
      appProvider,
      productId: product.id,
      cartProductId: cartProduct == null ? null : cartProduct.cartProductId,
      restaurantId: restaurantId,
      chainId: chainId,
      productTempCartData: productsProvider.productTempCartData,
      deleteExistingCart: shouldDeleteExistingCart,
    );
    await trackAddProductToCartEvent(productsProvider.productTempCartData.quantity);
    showToast(
        msg: Translations.of(context).get(cartProduct == null
            ? shouldDeleteExistingCart
                ? 'Cleared existing cart and added product to new cart successfully!'
                : 'Successfully added product to cart!'
            : 'Cart updated successfully!'));
    Navigator.of(context).pop();
  }

  EventTracking eventTracking = EventTracking.getActions();

  Future<void> trackViewProductDetailsEvent() async {
    Map<String, dynamic> eventParams = {
      'product_name': product.englishTitle,
      //Todo: get categoryEnglishTitle from API (product show endpoint)
      'product_category': categoryEnglishTitle,
      'product_cost': hasDiscountedPrice ? product.discountedPrice.raw : product.price.raw,
      'product_id': product.id,
      'restaurant_name': restaurantEnglishTitle,
      'product_options': productsProvider.productOptions != null && productsProvider.productOptions.length > 0,
    };
    await eventTracking.trackEvent(TrackingEvent.VIEW_PRODUCT_DETAILS, eventParams);
  }

  Future<void> trackAddProductToCartEvent(int quantity) async {
    Map<String, dynamic> eventParams = {
      'product_name': product.englishTitle,
      //Todo: get categoryEnglishTitle from API (product show endpoint)
      'product_category': categoryEnglishTitle,
      'restaurant_name': restaurantEnglishTitle,
      'product_cost': hasDiscountedPrice ? product.discountedPrice.raw : product.price.raw,
      'product_id': product.id,
      'item_quantity': quantity,
    };

    await eventTracking.trackEvent(TrackingEvent.ADD_PRODUCT_TO_CART, eventParams);
  }

  @override
  void initState() {
    productOptionsScrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Map<String, dynamic> data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      print('Route data: $data');
      productId = data["product_id"];
      cartProduct = data["cart_product"];
      categoryEnglishTitle = data["category_english_title"];
      restaurantEnglishTitle = data["restaurant_english_title"];

      if (cartProduct != null) {
        print('Cart product id: ${cartProduct.cartProductId}');
      }
      restaurantId = data["restaurant_id"];
      chainId = data["chain_id"];
      hasControls = data["has_controls"] == null ? true : data["has_controls"];
      productsProvider = Provider.of<ProductsProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      cartProvider = Provider.of<CartProvider>(context);

      _fetchAndSetProduct().then((_) {
        trackViewProductDetailsEvent();
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeightWithoutActionButton = screenSize.height - (buttonHeightSm + listItemVerticalPadding + actionButtonBottomPadding + 187);
    print('screenHeightWithoutActionButton');
    print(screenHeightWithoutActionButton);
    if (!_isLoadingProduct) {
      productTotalPrice = productsProvider.productTempCartData.productTotalPrice;
    }
    return AppScaffold(
      bgColor: AppColors.white,
      hasOverlayLoader: cartProvider.isLoadingAdjustFoodCartDataRequest,
      appBar: _isLoadingProduct
          ? null
          : AppBar(
              title: Text(product.title),
            ),
      body: _isLoadingProduct
          ? AppLoader()
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchAndSetProduct,
                    child: SingleChildScrollView(
                      controller: productOptionsScrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(minHeight: screenHeightWithoutActionButton),
                            child: Column(
                              children: [
                                Container(
                                  height: screenSize.height * 0.4,
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: product.media.cover,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        product.title,
                                        style: AppTextStyles.h2,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      if (product.description != null && product.description.raw != null && product.description.raw.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 20),
                                          child: Text(
                                            product.description.raw,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      FormattedPrices(
                                        price: product.price,
                                        discountedPrice: product.discountedPrice,
                                        isLarge: true,
                                      ),
                                    ],
                                  ),
                                ),
                                FoodProductOptions(
                                  productOptionsScrollController: productOptionsScrollController,
                                  product: product,
                                  productOptions: productsProvider.productOptions,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
                            color: AppColors.bg,
                            child: FoodCartControls(
                              quantity: productsProvider.productTempCartData.quantity,
                              action: (CartAction cartAction) => productsProvider.setProductTempQuantity(cartAction),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Consumer3<HomeProvider, AppProvider, AddressesProvider>(
                  builder: (c, homeProvider, appProvider, addressesProvider, _) => TotalButton(
                    onTap: () => submitProductCartData(context, appProvider, addressesProvider),
                    isRTL: appProvider.isRTL,
                    total: priceAndCurrency(productTotalPrice, homeProvider.foodCurrency),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LineAwesomeIcons.shopping_cart,
                          color: AppColors.white,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            Translations.of(context).get(cartProduct == null ? 'Add To Cart' : 'Update Cart'),
                            maxLines: 1,
                            style: AppTextStyles.button,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
