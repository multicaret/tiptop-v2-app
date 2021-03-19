import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AppBarCartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Consumer<CartProvider>(builder: (c, cart, _) {
      print(cart.doubleCartTotal);
      return cart == null && cart.doubleCartTotal != 0
          ? Container()
          : GestureDetector(
              onTap: () {
                //Todo: Navigate to cart screen
              },
              child: Container(
                width: 130,
                height: 33,
                padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                    Container(
                      height: 33,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(appProvider.isRTL ? 0 : 8),
                          bottomLeft: Radius.circular(appProvider.isRTL ? 0 : 8),
                          topRight: Radius.circular(appProvider.isRTL ? 8 : 0),
                          bottomRight: Radius.circular(appProvider.isRTL ? 8 : 0),
                        ),
                        boxShadow: [BoxShadow(blurRadius: 6, color: AppColors.shadowDark)],
                        color: AppColors.white,
                      ),
                      child: AppIcon.icon(LineAwesomeIcons.shopping_cart),
                    ),
                    Expanded(
                      child: Container(
                        height: 33,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        margin: EdgeInsets.only(left: appProvider.isRTL ? 10 : 0, right: appProvider.isRTL ? 0 : 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(appProvider.isRTL ? 8 : 0),
                            bottomLeft: Radius.circular(appProvider.isRTL ? 8 : 0),
                            topRight: Radius.circular(appProvider.isRTL ? 0 : 8),
                            bottomRight: Radius.circular(appProvider.isRTL ? 0 : 8),
                          ),
                          boxShadow: [BoxShadow(blurRadius: 6, color: AppColors.shadowDark)],
                          color: AppColors.primary,
                        ),
                        child: Text(
                          cart.cartTotal,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          style: cart.cartTotal.length > 12 ? AppTextStyles.subtitleXxsWhite : AppTextStyles.subtitleXsWhiteBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
