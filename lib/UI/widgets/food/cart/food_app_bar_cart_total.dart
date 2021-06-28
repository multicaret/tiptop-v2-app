import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/food_cart_page.dart';
import 'package:tiptop_v2/UI/widgets/cart/animated_cart_total.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';

class FoodAppBarCartTotal extends StatelessWidget {
  final bool isLoading;
  final bool requestError;
  final bool isRTL;

  FoodAppBarCartTotal({
    this.isLoading = false,
    this.requestError = false,
    @required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (c, cartProvider, _) {
        bool hideFoodCart =
            isLoading || cartProvider.noFoodCart || requestError || cartProvider.foodCart == null || cartProvider.foodCart.total == null;
        return AnimatedCartTotal(
          isRTL: isRTL,
          hideCart: hideFoodCart,
          route: FoodCartPage.routeName,
          isLoading: cartProvider.isLoadingAdjustFoodCartDataRequest,
          cartTotal: hideFoodCart ? '' : cartProvider.foodCart.total.formatted,
        );
      },
    );
  }
}
