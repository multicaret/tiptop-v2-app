import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/market/market_product_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_cached_network_image.dart';
import 'package:tiptop_v2/UI/widgets/formatted_prices.dart';
import 'package:tiptop_v2/UI/widgets/market/market_cart_controls.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class MarketProductListItem extends StatelessWidget {
  final int quantity;
  final Product product;
  final bool hasControls;
  final bool disabled;

  MarketProductListItem({
    this.quantity,
    @required this.product,
    this.hasControls = true,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    bool hasUnitTitle = product.unit != null && product.unit.title != null;

    void openMarketProductPage() {
      pushCupertinoPage(
        context,
        MarketProductPage(
          productId: product.id,
          hasControls: hasControls,
        ),
        rootNavigator: true,
      );
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
            onTap: disabled ? null : openMarketProductPage,
            child: Container(
              width: productListItemThumbnailSize,
              height: productListItemThumbnailSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AppCachedNetworkImage(
                  imageUrl: product.media.coverSmall,
                  width: productListItemThumbnailSize,
                  height: productListItemThumbnailSize,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: disabled ? null : openMarketProductPage,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title),
                    const SizedBox(height: 10),
                    if (product.unitText != null) Text(product.unitText, style: AppTextStyles.subtitleXs50),
                    FormattedPrices(
                      price: product.price,
                      discountedPrice: product.discountedPrice,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (hasControls)
            Container(
              width: 99,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 99,
                    height: 33,
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
                    ),
                    child: MarketCartControls(product: product, isListItem: true),
                  ),
                  if (hasUnitTitle)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        product.unit.title,
                        style: AppTextStyles.subtitleXxs50,
                        textAlign: TextAlign.center,
                      ),
                    )
                ],
              ),
            ),
          if (quantity != null && !hasControls)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bg,
              ),
              padding: const EdgeInsets.all(10),
              child: Text('$quantity'),
            )
        ],
      ),
    );
  }
}
