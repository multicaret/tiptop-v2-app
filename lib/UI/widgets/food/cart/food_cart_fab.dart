import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/food_cart_page.dart';
import 'package:tiptop_v2/UI/widgets/cart/cart_items_count_badge.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/food_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class FoodCartFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, CartProvider, FoodProvider>(
      builder: (c, appProvider, cartProvider, foodProvider, _) {
        bool hideFoodCart =
            foodProvider.isLoadingFoodHomeData || cartProvider.noFoodCart || foodProvider.foodHomeDataRequestError || !appProvider.isAuth;

        return Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: GestureDetector(
            onTap: hideFoodCart ? null : () => Navigator.of(context, rootNavigator: true).pushNamed(FoodCartPage.routeName),
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: Platform.isIOS ? 30 : 5),
                    height: 75,
                    width: 75,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        const BoxShadow(blurRadius: 10, color: AppColors.shadowDark),
                      ],
                    ),
                    child: Icon(
                      LineAwesomeIcons.shopping_cart,
                      size: 50,
                      color: hideFoodCart ? AppColors.primary50 : AppColors.secondary,
                    ),
                  ),
                  Positioned(
                    bottom: Platform.isIOS ? 30 : 5,
                    right: 0,
                    child: hideFoodCart
                        ? Container()
                        : CartItemsCountBadge(
                            count: cartProvider.foodCart.productsCount,
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
