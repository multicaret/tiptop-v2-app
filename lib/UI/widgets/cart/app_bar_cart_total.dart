import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/food_cart_page.dart';
import 'package:tiptop_v2/UI/pages/market/market_cart_page.dart';
import 'package:tiptop_v2/UI/widgets/cart/animated_cart_total.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';

class AppBarCartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer3<CartProvider, HomeProvider, AppProvider>(
      builder: (c, cartProvider, homeProvider, appProvider, _) {
        bool hideMarketCart = homeProvider.isLoadingHomeData || cartProvider.noMarketCart || homeProvider.marketHomeDataRequestError;
        bool hideFoodCart = homeProvider.isLoadingHomeData || cartProvider.noFoodCart || homeProvider.foodHomeDataRequestError;

        return homeProvider.channelIsMarket
            ? AnimatedCartTotal(
                isRTL: appProvider.isRTL,
                hideCart: hideMarketCart,
                route: MarketCartPage.routeName,
                isLoading: cartProvider.isLoadingAdjustCartQuantityRequest,
                cartTotal: hideMarketCart ? '' : cartProvider.marketCart.total.formatted,
              )
            : AnimatedCartTotal(
                isRTL: appProvider.isRTL,
                hideCart: hideFoodCart,
                route: FoodCartPage.routeName,
                isLoading: cartProvider.isLoadingAdjustFoodCartDataRequest,
                cartTotal: hideFoodCart ? '' : cartProvider.foodCart.total.formatted,
              );
      },
    );
  }
}
