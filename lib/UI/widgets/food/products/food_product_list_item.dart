import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/food/food_product_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_cached_network_image.dart';
import 'package:tiptop_v2/UI/widgets/formatted_prices.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/branch.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FoodProductListItem extends StatelessWidget {
  final Product product;
  final Branch restaurant;
  final String categoryEnglishTitle;

  FoodProductListItem({
    @required this.product,
    @required this.restaurant,
    this.categoryEnglishTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: product.isDisabled ? 0.4 : 1,
      child: Material(
        color: AppColors.white,
        child: InkWell(
          onTap: () {
            if (product.isDisabled) {
              showToast(msg: Translations.of(context).get("This item is not available"));
            } else {
              pushCupertinoPage(
                context,
                FoodProductPage(
                  productId: product.id,
                  restaurantId: restaurant.id,
                  chainId: restaurant.chain.id,
                  restaurantIsOpen: restaurant.workingHours.isOpen,
                  restaurantEnglishTitle: restaurant.englishTitle,
                  categoryEnglishTitle: categoryEnglishTitle,
                ),
                rootNavigator: true,
              );
            }
          },
          child: Container(
            height: listItemHeight,
            padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.title, style: AppTextStyles.bodyBold),
                      const SizedBox(height: 10),
                      if (product.excerpt != null && product.excerpt.formatted != null)
                        Expanded(
                          child: Text(
                            product.excerpt.raw,
                            style: AppTextStyles.subtitle50,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (product.price.raw != null && product.price.raw > 0)
                        FormattedPrices(
                          price: product.price,
                          discountedPrice: product.discountedPrice,
                        )
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 0.5, color: AppColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppCachedNetworkImage(
                      imageUrl: product.media.coverSmall,
                      width: listItemThumbnailSize,
                      height: listItemThumbnailSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
