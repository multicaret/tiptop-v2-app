import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CartItemsCountBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (c, cart, _) => cart.cartProductsCount == 0
          ? Container()
          : Container(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.secondaryDark,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${cart.cartProductsCount}',
                  style: cart.cartProductsCount.toString().length > 1 ? AppTextStyles.subtitleXsBold : AppTextStyles.subtitleBold,
                ),
              ),
            ),
    );
  }
}
