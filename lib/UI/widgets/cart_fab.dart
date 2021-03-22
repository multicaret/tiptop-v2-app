import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/cart_page.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CartFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (c, cart, _) => Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (c) => CartPage(),
              ),
            );
          },
          child: Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 30),
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: AppColors.shadowDark),
                    ],
                  ),
                  child: AppIcon.iconLgSecondary(LineAwesomeIcons.shopping_cart),
                ),
                if (cart.cartProductsCount > 0)
                  Positioned(
                    bottom: 30,
                    right: 0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryDark,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(blurRadius: 6, color: AppColors.shadowDark),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${cart.cartProductsCount}',
                        style: cart.cartProductsCount.toString().length > 1 ? AppTextStyles.subtitleXsBold : AppTextStyles.subtitleBold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
