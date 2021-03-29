import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/market/cart_page.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CartFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, CartProvider, HomeProvider>(
      builder: (c, appProvider, cartProvider, homeProvider, _) {
        bool hideCart = cartProvider.noCart || homeProvider.homeDataRequestError || homeProvider.noBranchFound || !appProvider.isAuth;

        return Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: GestureDetector(
            onTap: hideCart ? null : () => Navigator.of(context, rootNavigator: true).pushNamed(CartPage.routeName),
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: Platform.isIOS ? 30 : 10),
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
                  if (cartProvider.cartProductsCount > 0 && !hideCart)
                    Positioned(
                      bottom: Platform.isIOS ? 30 : 10,
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
                          '${cartProvider.cartProductsCount}',
                          style: cartProvider.cartProductsCount.toString().length > 1 ? AppTextStyles.subtitleXsBold : AppTextStyles.subtitleBold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
