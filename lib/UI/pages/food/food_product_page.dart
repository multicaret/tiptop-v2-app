import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_cached_network_image.dart';
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
import 'package:tiptop_v2/providers/food_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../../widgets/UI/app_scaffold.dart';

class FoodProductPage extends StatefulWidget {
  final int productId;
  final CartProduct cartProduct;
  final String categoryEnglishTitle;
  final String restaurantEnglishTitle;
  final int restaurantId;
  final bool restaurantIsOpen;
  final int chainId;
  final bool hasControls;

  FoodProductPage({
    @required this.productId,
    this.cartProduct,
    this.categoryEnglishTitle,
    this.restaurantEnglishTitle,
    this.restaurantId,
    this.chainId,
    this.restaurantIsOpen = true,
    this.hasControls = true,
  });

  // static const routeName = '/food-product';

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
  bool restaurantIsOpen = true;
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

  void invalidOptionsAction() {
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
  }

  Future<void> submitProductCartData(BuildContext context, AppProvider appProvider, AddressesProvider addressesProvider) async {
    bool shouldProceed = shouldProceedWithAuthRequest(
      context,
      appProvider,
      addressIsSelected: addressesProvider.addressIsSelected,
    );
    if (shouldProceed) {
      bool optionsAreValid = productsProvider.validateProductOptions(context);
      if (!optionsAreValid) {
        invalidOptionsAction();
        return;
      }
      if (chainId == null || restaurantId == null) {
        print('Either chain id ($chainId) or restaurant id ($restaurantId) is null');
        return;
      }
      if (cartProvider.foodCart == null) {
        print("Food cart is null!");
      }
      bool shouldDeleteExistingCart = false;
      bool hasCartInDifferentRestaurant = cartProvider.foodCart.restaurant != null && (cartProvider.foodCart.restaurant.id != restaurantId);

      if (hasCartInDifferentRestaurant) {
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
      productId = widget.productId;
      cartProduct = widget.cartProduct;
      categoryEnglishTitle = widget.categoryEnglishTitle;
      restaurantEnglishTitle = widget.restaurantEnglishTitle;

      if (cartProduct != null) {
        print('Cart product id: ${cartProduct.cartProductId}');
      }

      restaurantId = widget.restaurantId;
      restaurantIsOpen = widget.restaurantIsOpen;
      hasControls = widget.hasControls;
      productsProvider = Provider.of<ProductsProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      cartProvider = Provider.of<CartProvider>(context);

      _fetchAndSetProduct().then((_) {
        if (restaurantId == null) {
          restaurantId = product.branchId;
        }
        if (chainId == null) {
          chainId = product.chainId;
        }
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
                                  child: AppCachedNetworkImage(imageUrl: product.media.cover),
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
                                      if (product.price.raw != null && product.price.raw > 0)
                                        FormattedPrices(
                                          price: product.price,
                                          discountedPrice: product.discountedPrice,
                                          isLarge: true,
                                        ),
                                    ],
                                  ),
                                ),
                                IgnorePointer(
                                  ignoring: !restaurantIsOpen,
                                  child: Opacity(
                                    opacity: restaurantIsOpen ? 1 : 0.4,
                                    child: FoodProductOptions(
                                      productOptionsScrollController: productOptionsScrollController,
                                      product: product,
                                      productOptions: productsProvider.productOptions,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IgnorePointer(
                            ignoring: !restaurantIsOpen,
                            child: Opacity(
                              opacity: restaurantIsOpen ? 1 : 0.4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
                                color: AppColors.bg,
                                child: FoodCartControls(
                                  quantity: productsProvider.productTempCartData.quantity,
                                  action: (CartAction cartAction) => productsProvider.setProductTempQuantity(cartAction),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                restaurantIsOpen
                    ? Consumer3<FoodProvider, AppProvider, AddressesProvider>(
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
                        builder: (c, foodProvider, appProvider, addressesProvider, child) => TotalButton(
                          onTap: () => submitProductCartData(context, appProvider, addressesProvider),
                          isRTL: appProvider.isRTL,
                          total: priceAndCurrency(productTotalPrice, foodProvider.foodCurrency),
                          child: child,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: actionButtonBottomPadding,
                          right: screenHorizontalPadding,
                          left: screenHorizontalPadding,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          border: Border(top: BorderSide(color: AppColors.border)),
                        ),
                        child: AppButtons.secondarySm(
                          child: Text(
                            Translations.of(context).get("This restaurant is closed right now!"),
                            maxLines: 1,
                            style: AppTextStyles.button,
                          ),
                          onPressed: () {},
                        ),
                      ),
              ],
            ),
    );
  }
}
