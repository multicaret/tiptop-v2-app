import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/market/products/list_product_item.dart';
import 'package:tiptop_v2/UI/widgets/order_button.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class MarketCartPage extends StatelessWidget {
  static const routeName = '/market-cart';

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, HomeProvider, CartProvider>(
      builder: (c, appProvider, homeProvider, cartProvider, _) => AppScaffold(
        hasCurve: false,
        hasOverlayLoader: cartProvider.isLoadingClearCartRequest,
        appBar: AppBar(
          title: Text(Translations.of(context).get('Cart')),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmAlertDialog(
                    title: 'Are you sure you want to empty your cart?',
                  ),
                ).then((response) {
                  if (response != null && response) {
                    cartProvider.clearCart(appProvider).then((_) {
                      showToast(msg: 'Cart Cleared Successfully!');
                      Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppWrapper.routeName);
                    }).catchError((e) {
                      showToast(msg: 'Error clearing cart!');
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
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: cartProvider.marketCartProducts
                    .map((cartProduct) => ListProductItem(
                          product: cartProduct.product,
                          quantity: cartProduct.quantity,
                        ))
                    .toList(),
              ),
            ),
            OrderButton(
              cartProvider: cartProvider,
              total: cartProvider.marketCart.total.formatted,
              isRTL: appProvider.isRTL,
            ),
          ],
        ),
      ),
    );
  }
}
