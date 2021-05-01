import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/market/products/market_product_list_item.dart';
import 'package:tiptop_v2/UI/widgets/total_button.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

import 'order/market_checkout_page.dart';

class MarketCartPage extends StatelessWidget {
  static const routeName = '/market-cart';

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, HomeProvider, CartProvider>(
      builder: (c, appProvider, homeProvider, cartProvider, _) {
        return AppScaffold(
          hasCurve: false,
          hasOverlayLoader: cartProvider.isLoadingClearMarketCartRequest || cartProvider.isLoadingDeleteMarketCartProduct,
          appBar: AppBar(
            title: Text(Translations.of(context).get("Market Cart")),
            actions: [
              if (!cartProvider.noMarketCart)
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmAlertDialog(
                        title: 'Are you sure you want to empty your cart?',
                      ),
                    ).then((response) {
                      if (response != null && response) {
                        cartProvider.clearMarketCart(appProvider).then((_) {
                          showToast(msg: Translations.of(context).get("Cart Cleared Successfully!"));
                          Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppWrapper.routeName);
                        }).catchError((e) {
                          showToast(msg: Translations.of(context).get("Error clearing cart!"));
                        });
                      }
                    });
                  },
                  icon: AppIcons.iconPrimary(FontAwesomeIcons.trashAlt),
                )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: cartProvider.noMarketCart
                    ? Center(
                        child: TextButton(
                          child: Text(Translations.of(context).get("Your Cart Is Empty, Shop Now!")),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    : ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: cartProvider.marketCart.cartProducts.length,
                        itemBuilder: (c, i) {
                          List<CartProduct> cartProducts = cartProvider.marketCart.cartProducts;
                          return Dismissible(
                            key: Key('${cartProducts[i].product.id}'),
                            direction: DismissDirection.endToStart,
                            background: Consumer<AppProvider>(
                              builder: (c, appProvider, _) => Container(
                                color: Colors.red,
                                alignment: appProvider.isRTL ? Alignment.centerLeft : Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
                                child: AppIcons.iconMdWhite(FontAwesomeIcons.trashAlt),
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                final response = await showDialog(
                                  context: context,
                                  builder: (context) => ConfirmAlertDialog(
                                    title: 'Are you sure you want to delete this product from your cart?',
                                  ),
                                );
                                return response == null ? false : response;
                              }
                              return false;
                            },
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                int productIdToDelete = cartProducts[i].product.id;
                                cartProducts.removeAt(i);
                                cartProvider.deleteProductFromMarketCart(context: context, appProvider: appProvider, productId: productIdToDelete);
                              }
                            },
                            child: MarketProductListItem(
                              product: cartProducts[i].product,
                              quantity: cartProducts[i].quantity,
                            ),
                          );
                        },
                      ),
              ),
              if (!cartProvider.noMarketCart)
                TotalButton(
                  total: cartProvider.marketCart.total.formatted,
                  isLoading: cartProvider.isLoadingAdjustCartQuantityRequest,
                  isRTL: appProvider.isRTL,
                  child: Text(Translations.of(context).get("Continue")),
                  onTap: () {
                    if (cartProvider.marketCart == null ||
                        cartProvider.marketCart.total == null ||
                        cartProvider.marketCart.total.raw == 0 ||
                        cartProvider.marketCart.total.raw < homeProvider.marketHomeData.branch.tiptopDelivery.minimumOrder.raw) {
                      showToast(
                          msg: Translations.of(context).get('Order total should be greater than: {branchMinimumOrder}',
                              args: [homeProvider.marketHomeData.branch.tiptopDelivery.minimumOrder.formatted]));
                    } else {
                      Navigator.of(context, rootNavigator: true).pushNamed(MarketCheckoutPage.routeName);
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
