import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/list_product_item.dart';
import 'package:tiptop_v2/UI/widgets/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/order_button.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

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
                    cartProvider.clearCart(appProvider, homeProvider).then((_) {
                      showToast(msg: 'Cart Cleared Successfully!');
                      Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppWrapper.routeName);
                    }).catchError((e) {
                      showToast(msg: 'Error clearing cart!');
                    });
                  }
                });
              },
              icon: AppIcon.iconPrimary(FontAwesomeIcons.trashAlt),
            )
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom: 105),
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: cartProvider.cartProducts
                      .map((cartProduct) => CartProductItem(
                            product: cartProduct.product,
                            quantity: cartProduct.quantity,
                          ))
                      .toList(),
                ),
              ),
            ),
            OrderButton(
              cartProvider: cartProvider,
              isRTL: appProvider.isRTL,
            ),
          ],
        ),
      ),
    );
  }
}
