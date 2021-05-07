import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/profile/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

import 'cart_animated_button.dart';

class MarketCartControls extends StatefulWidget {
  final Product product;
  final bool isModalControls;
  final bool isListItem;

  MarketCartControls({
    @required this.product,
    this.isModalControls = false,
    this.isListItem = false,
  });

  @override
  _MarketCartControlsState createState() => _MarketCartControlsState();
}

class _MarketCartControlsState extends State<MarketCartControls> {
  AppProvider appProvider;
  CartProvider cartProvider;
  AddressesProvider addressesProvider;
  bool _isInit = true;
  bool productHasDiscountedPrice = false;

  Future<void> adjustMarketProductQuantity(CartAction action) async {
    if (!appProvider.isAuth) {
      showToast(msg: Translations.of(context).get("You Need to Log In First!"));
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
    } else if (!addressesProvider.addressIsSelected) {
      showToast(msg: Translations.of(context).get("You Need to Select Address First!"));
      Navigator.of(context, rootNavigator: true).pushNamed(
        AddressesPage.routeName,
        arguments: {'should_pop_after_selection': true},
      );
    } else {
      print('$action ${widget.product.id} ${widget.product.title}');
      final returnedQuantity = await cartProvider.adjustMarketProductQuantity(
        appProvider: appProvider,
        isAdding: action == CartAction.ADD,
        product: widget.product,
        context: context,
      );
      if (returnedQuantity == 401) {
        showToast(msg: Translations.of(context).get("You Need to Log In First!"));
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
        return;
      }
      trackAddProductToCartEvent(returnedQuantity);
    }
  }

  EventTracking eventTracking = EventTracking.getActions();

  Future<void> trackAddProductToCartEvent(int quantity) async {
    Map<String, dynamic> eventParams = {
      'product_name': widget.product.englishTitle,
      //Todo: get the next 2 params from API (product show endpoint)
      'product_category': '',
      'product_parent_category': '',
      'product_cost': productHasDiscountedPrice ? widget.product.discountedPrice.raw : widget.product.price.raw,
      'product_id': widget.product.id,
      'item_quantity': quantity,
    };

    await eventTracking.trackEvent(TrackingEvent.ADD_PRODUCT_TO_CART, eventParams);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context);
      cartProvider = Provider.of<CartProvider>(context);
      productHasDiscountedPrice = widget.product.discountedPrice != null &&
          widget.product.discountedPrice.raw != 0 &&
          widget.product.discountedPrice.raw < widget.product.price.raw;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenThirdWidth = (screenSize.width - (screenHorizontalPadding * 2)) / 3;
    double cartButtonHeight = widget.isModalControls ? buttonHeightSm : getCartControlButtonHeight(context);
    int quantity = cartProvider.getProductQuantity(widget.product.id);
    bool disableAddition = cartProvider.requestedMoreThanAvailableQuantity[widget.product.id] ?? false;
    bool isLoadingQuantity = cartProvider.isLoadingAdjustMarketProductQuantityRequest[widget.product.id] ?? false;

    return Stack(
      children: [
        //Quantity
        Positioned(
          left: widget.isModalControls ? screenThirdWidth : cartButtonHeight,
          height: cartButtonHeight,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.isModalControls ? screenThirdWidth : cartButtonHeight,
            height: cartButtonHeight,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(quantity == 0 ? 10 : 0),
              boxShadow: [
                const BoxShadow(blurRadius: 6, color: AppColors.shadow),
              ],
            ),
            child: Center(
              child: isLoadingQuantity
                  ? SpinKitFadingCircle(color: AppColors.primary, size: cartButtonHeight * 0.6)
                  : Text(
                      quantity == 0 ? '' : '$quantity',
                      style: quantity.toString().length >= 2 ? AppTextStyles.subtitleXsBold : AppTextStyles.subtitleBold,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    ),
            ),
          ),
        ),
        //Remove Button
        CartAnimatedButton(
          cartAction: CartAction.REMOVE,
          isRTL: appProvider.isRTL,
          quantity: quantity,
          onTap: isLoadingQuantity ? null : () => adjustMarketProductQuantity(CartAction.REMOVE),
          isModalControls: widget.isModalControls,
        ),
        //Add Button
        CartAnimatedButton(
          cartAction: CartAction.ADD,
          isRTL: appProvider.isRTL,
          quantity: quantity,
          isProductDisabled: widget.product.isDisabled,
          onTap: disableAddition || isLoadingQuantity ? null : () => adjustMarketProductQuantity(CartAction.ADD),
          isModalControls: widget.isModalControls,
          isLoadingFirstAddition: quantity == 0 && isLoadingQuantity,
        ),
        if (widget.isModalControls || widget.isListItem)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: 0,
            left: 0,
            top: quantity == 0 ? 0 : cartButtonHeight,
            bottom: quantity == 0 ? 0 : -cartButtonHeight,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: quantity == 0 ? 1 : 0,
              child: AppButtons.primary(
                onPressed: () => isLoadingQuantity ? {} : adjustMarketProductQuantity(CartAction.ADD),
                child: quantity == 0 && isLoadingQuantity
                    ? SpinKitThreeBounce(
                        color: AppColors.white,
                        size: 20,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LineAwesomeIcons.shopping_cart,
                            color: AppColors.white,
                            size: widget.isListItem ? 14 : 20,
                          ),
                          SizedBox(width: widget.isListItem ? 2 : 5),
                          Flexible(
                            child: Text(
                              Translations.of(context).get("Add To Cart"),
                              maxLines: 1,
                              style: widget.isListItem ? AppTextStyles.subtitleXxsWhite : AppTextStyles.button,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
