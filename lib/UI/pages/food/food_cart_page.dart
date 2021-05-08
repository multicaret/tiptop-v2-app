import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/food/products/food_cart_product_list_item.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_min_horizontal_list_item.dart';
import 'package:tiptop_v2/UI/widgets/total_button.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

import 'order/food_checkout_page.dart';

class FoodCartPage extends StatelessWidget {
  static const routeName = '/food-cart';

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, CartProvider>(
      builder: (c, appProvider, cartProvider, _) {
        List<CartProduct> cartProducts = cartProvider.foodCart.cartProducts;
        return AppScaffold(
          hasOverlayLoader: cartProvider.isLoadingClearFoodCartRequest || cartProvider.isLoadingDeleteFoodCartProduct,
          appBar: AppBar(
            title: Text(Translations.of(context).get("Food Cart")),
            actions: [
              if (!cartProvider.noFoodCart)
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmAlertDialog(
                        title: 'Are you sure you want to empty your cart?',
                      ),
                    ).then((response) {
                      if (response != null && response) {
                        cartProvider.clearFoodCart(context, appProvider);
                      }
                    });
                  },
                  icon: AppIcons.iconPrimary(FontAwesomeIcons.trashAlt),
                )
            ],
          ),
          body: Column(
            children: [
              if (!cartProvider.noFoodCart) RestaurantMinHorizontalListItem(restaurant: cartProvider.foodCart.restaurant),
              Expanded(
                child: cartProvider.noFoodCart
                    ? Center(
                        child: TextButton(
                          child: Text(Translations.of(context).get("Your Cart Is Empty, Shop Now!")),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    : ListView.builder(
                        itemCount: cartProducts.length,
                        itemBuilder: (c, i) {
                          bool isLoadingAdjustQuantity =
                              cartProvider.isLoadingAdjustFoodProductQuantityRequest[cartProducts[i].cartProductId] ?? false;

                          return Padding(
                            padding: EdgeInsets.only(
                              top: i == 0 ? 20 : 0,
                              bottom: i == cartProducts.length - 1 ? 20 : 0,
                            ),
                            child: FoodCartProductListItem(
                              restaurantId: cartProvider.foodCart.restaurant.id,
                              chainId: cartProvider.foodCart.restaurant.chain.id,
                              cartProduct: cartProducts[i],
                              isLoadingAdjustQuantity: isLoadingAdjustQuantity,
                              editQuantityAction: (CartAction _cartAction) => _editCartProductQuantity(
                                context: context,
                                appProvider: appProvider,
                                cartProvider: cartProvider,
                                cartAction: _cartAction,
                                cartProduct: cartProducts[i],
                              ),
                              dismissAction: () {
                                int cartProductIdToDelete = cartProducts[i].cartProductId;
                                cartProducts.removeAt(i);
                                cartProvider.deleteProductFromFoodCart(
                                  context: context,
                                  appProvider: appProvider,
                                  cartProductId: cartProductIdToDelete,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
              if (!cartProvider.noFoodCart)
                TotalButton(
                  total: cartProvider.foodCart.total.formatted,
                  isLoading: cartProvider.isLoadingAdjustFoodCartDataRequest,
                  isRTL: appProvider.isRTL,
                  child: Text(Translations.of(context).get("Continue")),
                  onTap: () {
                    DoubleRawStringFormatted restaurantMinimumOrder =
                        getRestaurantMinimumOrder(cartProvider.foodCart.restaurant, cartProvider.foodCart.total.raw);
                    if (restaurantMinimumOrder != null && cartProvider.foodCart.total.raw < restaurantMinimumOrder.raw) {
                      showToast(
                        msg: Translations.of(context).get(
                          'Order total should be greater than: {branchMinimumOrder}',
                          args: [restaurantMinimumOrder.formatted],
                        ),
                      );
                      return;
                    }
                    Navigator.of(context, rootNavigator: true).pushNamed(FoodCheckoutPage.routeName);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editCartProductQuantity({
    BuildContext context,
    CartAction cartAction,
    AppProvider appProvider,
    CartProvider cartProvider,
    CartProduct cartProduct,
  }) async {
    if (cartProduct.quantity == 1 && cartAction == CartAction.REMOVE) {
      showDialog(
        context: context,
        builder: (context) => ConfirmAlertDialog(
          title: 'Are you sure you want to delete this product from your cart?',
        ),
      ).then((response) {
        if (response != null && response) {
          cartProvider.deleteProductFromFoodCart(
            context: context,
            appProvider: appProvider,
            cartProductId: cartProduct.cartProductId,
          );
        }
        return;
      });
    } else {
      print('cartAction: $cartAction');
      int newQuantity = cartAction == CartAction.ADD ? cartProduct.quantity + 1 : cartProduct.quantity - 1;
      ProductCartData productCartData = ProductCartData(
        productId: cartProduct.product.id,
        quantity: newQuantity,
        selectedOptions: cartProduct.selectedOptions,
      );
      print(cartProduct.selectedOptions.map((x) => x.toJson()).toList());
      await cartProvider.adjustFoodProductCart(
        context,
        appProvider,
        productId: cartProduct.product.id,
        cartProductId: cartProduct.cartProductId,
        restaurantId: cartProvider.foodCart.restaurant.id,
        chainId: cartProvider.foodCart.restaurant.chain.id,
        productTempCartData: productCartData,
        adjustingQuantity: true,
      );
      if (cartAction == CartAction.ADD) {
        EventTracking eventTracking = EventTracking.getActions();

        Map<String, dynamic> eventParams = {
          'product_name': cartProduct.product.englishTitle,
          //Todo: get the next 2 params from API (product show endpoint)
          'product_category': '',
          'product_parent_category': '',
          'product_cost': cartProduct.totalPrice.raw,
          'product_id': cartProduct.product.id,
          'item_quantity': newQuantity,
        };

        await eventTracking.trackEvent(TrackingEvent.ADD_PRODUCT_TO_CART, eventParams);
      }
    }
  }
}
