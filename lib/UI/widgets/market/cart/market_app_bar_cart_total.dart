import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/market/market_cart_page.dart';
import 'package:tiptop_v2/UI/widgets/cart/animated_cart_total.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';

class MarketAppBarCartTotal extends StatelessWidget {
  final bool isLoading;
  final bool requestError;
  final bool isRTL;

  MarketAppBarCartTotal({
    this.isLoading = false,
    this.requestError = false,
    @required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (c, cartProvider, _) {
        bool hideMarketCart =
            isLoading || cartProvider.noMarketCart || requestError || cartProvider.marketCart == null || cartProvider.marketCart.total == null;
        return AnimatedCartTotal(
          isRTL: isRTL,
          hideCart: hideMarketCart,
          route: MarketCartPage.routeName,
          isLoading: cartProvider.isLoadingAdjustCartQuantityRequest,
          cartTotal: hideMarketCart ? '' : cartProvider.marketCart.total.formatted,
        );
      },
    );
  }
}
