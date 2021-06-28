import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/market/market_product_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_cahched_network_image.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

import '../../formatted_prices.dart';
import '../market_cart_controls.dart';

class MarketGridProductItem extends StatelessWidget {
  final Product product;
  final String categoryEnglishTitle;
  final String parentCategoryEnglishTitle;

  const MarketGridProductItem({
    @required this.product,
    this.categoryEnglishTitle,
    this.parentCategoryEnglishTitle,
  });

  void openMarketProductPage(BuildContext context) {
    if (product.isDisabled) {
      showToast(msg: Translations.of(context).get("This item is not available"));
    } else {
      pushCupertinoPage(
        context,
        MarketProductPage(
          productId: product.id,
          hasControls: true,
          categoryEnglishTitle: categoryEnglishTitle,
          parentCategoryEnglishTitle: parentCategoryEnglishTitle,
        ),
        rootNavigator: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasUnitTitle = product.unit != null && product.unit.title != null;
    // print('rebuilt grid product item ${product.title}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: getColItemHeight(3, context) + (getCartControlButtonHeight(context) / 2) + (hasUnitTitle ? marketProductUnitTitleHeight : 0),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => openMarketProductPage(context),
                child: Opacity(
                  opacity: product.isDisabled ? 0.5 : 1,
                  child: Consumer<CartProvider>(builder: (c, cartProvider, _) {
                    int productCartQuantity = cartProvider.getProductQuantity(product.id);

                    return Container(
                      height: getColItemHeight(3, context),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5, color: productCartQuantity > 0 ? AppColors.primary : AppColors.border),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: AppCachedNetworkImage(
                          imageUrl: product.media.coverSmall,
                          height: getColItemHeight(3, context),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Positioned(
                bottom: hasUnitTitle ? marketProductUnitTitleHeight : 0,
                left: cartControlsMargin,
                right: cartControlsMargin,
                height: getCartControlButtonHeight(context),
                child: MarketCartControls(
                  product: product,
                  categoryEnglishTitle: categoryEnglishTitle,
                  parentCategoryEnglishTitle: parentCategoryEnglishTitle,
                ),
              ),
              if (hasUnitTitle)
                Positioned(
                  bottom: 0,
                  height: marketProductUnitTitleHeight,
                  right: 0,
                  left: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      product.unit.title,
                      style: AppTextStyles.subtitleXxs50,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Opacity(
            opacity: product.isDisabled ? 0.5 : 1,
            child: GestureDetector(
              onTap: () => openMarketProductPage(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  FormattedPrices(
                    price: product.price,
                    discountedPrice: product.discountedPrice,
                  ),
                  if (product.unitText != null) Expanded(child: Text(product.unitText, style: AppTextStyles.subtitleXs50))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
