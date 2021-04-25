import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/total_button.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

import '../../app_wrapper.dart';
import '../checkout_page.dart';

class FoodCartPage extends StatelessWidget {
  static const routeName = '/food-cart';

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, CartProvider>(
      builder: (c, appProvider, cartProvider, _) {
/*        if (cartProvider.noFoodCart && !cartProvider.isLoadingAdjustFoodCartDataRequest) {
          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.of(context).pop();
          });
        }*/

        return AppScaffold(
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
                        showToast(msg: Translations.of(context).get('Cart Cleared Successfully!'));
                        Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppWrapper.routeName);
                      }).catchError((e) {
                        showToast(msg: Translations.of(context).get('Error clearing cart!'));
                      });
                    }
                  });
                },
                icon: AppIcons.iconPrimary(FontAwesomeIcons.trashAlt),
              )
            ],
          ),
          body: Center(child: Text('Food Cart')),
//           body: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   border: Border(
//                     bottom: BorderSide(color: AppColors.border),
//                   ),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
//                 child: Row(
//                   children: [
// /*                    CachedNetworkImage(
//                       width: restaurantLogoSize,
//                       height: restaurantLogoSize,
//                       imageUrl: cartProvider.foodCart.restaurant.chain.media.logo,
//                       placeholder: (_, __) => SpinKitDoubleBounce(
//                         color: AppColors.secondary,
//                         size: restaurantLogoSize / 2,
//                       ),
//                     ),*/
//                     Expanded(
//                       child: Text(cartProvider.foodCart.restaurant.title),
//                     ),
//                     AppIcons.icon(appProvider.isRTL ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(itemBuilder: (c, i) {
//                   return Container();
//                 }),
//               ),
//               TotalButton(
//                 total: cartProvider.foodCart.total.formatted,
//                 isLoading: cartProvider.isLoadingAdjustFoodCartDataRequest,
//                 isRTL: appProvider.isRTL,
//                 child: Text(Translations.of(context).get('Continue')),
//                 onTap: () {
//                   Navigator.of(context, rootNavigator: true).pushNamed(CheckoutPage.routeName);
//                 },
//               ),
//             ],
//           ),
        );
      },
    );
  }
}
