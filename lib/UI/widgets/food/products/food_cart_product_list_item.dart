import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/food/food_product_page.dart';
import 'package:tiptop_v2/UI/widgets/formatted_prices.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../food_cart_controls.dart';

class FoodCartProductListItem extends StatelessWidget {
  final int restaurantId;
  final int chainId;
  final CartProduct cartProduct;
  final bool hasControls;

  FoodCartProductListItem({
    @required this.restaurantId,
    @required this.chainId,
    @required this.cartProduct,
    this.hasControls = true,
  });

  @override
  Widget build(BuildContext context) {
    void openFoodProductPage() {
      Navigator.of(context, rootNavigator: true).pushNamed(FoodProductPage.routeName, arguments: {
        "product_id": cartProduct.product.id,
        "has_controls": hasControls,
        "cart_product": cartProduct,
        'chain_id': chainId,
        'restaurant_id': restaurantId,
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: AppColors.border),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: openFoodProductPage,
            child: Container(
              width: productListItemThumbnailSize,
              height: productListItemThumbnailSize,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 1.5),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(cartProduct.product.media.coverThumbnail),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: openFoodProductPage,
              child: Container(
                constraints: BoxConstraints(minHeight: productListItemThumbnailSize),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cartProduct.product.title),
                    const SizedBox(height: 10),
                    if (cartProduct.product.unitText != null) Text(cartProduct.product.unitText, style: AppTextStyles.subtitleXs50),
                    FormattedPrices(
                      price: cartProduct.totalPrice,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (hasControls)
            Container(
              width: 99,
              height: 33,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
              ),
              child: FoodCartControls(
                quantity: cartProduct.quantity,
                action: (CartAction cartAction) {},
                isMin: true,
              ),
            ),
          if (cartProduct.quantity != null && !hasControls)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bg,
              ),
              padding: const EdgeInsets.all(10),
              child: Text('${cartProduct.quantity}'),
            )
        ],
      ),
    );
  }
}
