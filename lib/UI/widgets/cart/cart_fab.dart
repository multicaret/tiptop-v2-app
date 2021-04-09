import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/market/market_cart_page.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import 'cart_items_count_badge.dart';

class CartFAB extends StatelessWidget {
  Function getCartTabFunction(BuildContext context, bool _hideMarketCart, bool _hideFoodCart, bool _channelIsMarket) {
    if (_channelIsMarket) {
      return _hideMarketCart ? null : () => Navigator.of(context, rootNavigator: true).pushNamed(MarketCartPage.routeName);
    } else {
      return _hideFoodCart ? null : () => Navigator.of(context, rootNavigator: true).pushNamed(MarketCartPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, CartProvider, HomeProvider>(
      builder: (c, appProvider, cartProvider, homeProvider, _) {
        bool hideMarketCart = cartProvider.noMarketCart || homeProvider.marketHomeDataRequestError || !appProvider.isAuth;
        bool hideFoodCart = cartProvider.noFoodCart || homeProvider.foodHomeDataRequestError || !appProvider.isAuth;

        return Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: GestureDetector(
            onTap: getCartTabFunction(context, hideMarketCart, hideFoodCart, homeProvider.channelIsMarket),
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
                    child: homeProvider.channelIsMarket
                        ? cartProvider.isLoadingAdjustCartQuantityRequest
                            ? SpinKitFadingCircle(
                                color: AppColors.secondary,
                                size: 30,
                              )
                            : Icon(
                                LineAwesomeIcons.shopping_cart,
                                size: 50,
                                color: hideMarketCart ? AppColors.primary50 : AppColors.secondary,
                              )
                        : Icon(
                            LineAwesomeIcons.shopping_cart,
                            size: 50,
                            color: hideFoodCart ? AppColors.primary50 : AppColors.secondary,
                          ),
                  ),
                  homeProvider.channelIsMarket
                      ? Positioned(
                          bottom: Platform.isIOS ? 30 : 10,
                          right: 0,
                          child: hideMarketCart
                              ? Container()
                              : CartItemsCountBadge(
                                  count: cartProvider.marketCart.productsCount,
                                ),
                        )
                      : Positioned(
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
