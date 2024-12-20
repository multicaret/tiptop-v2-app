import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_cached_network_image.dart';
import 'package:tiptop_v2/UI/widgets/UI/rating_info.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_favorite_button.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/branch.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class RestaurantCoverWithInfo extends StatelessWidget {
  final Branch restaurant;
  final Function favoriteAction;
  final double height;
  final bool hasBorderRadius;
  final bool hasRating;

  const RestaurantCoverWithInfo({
    @required this.restaurant,
    this.favoriteAction,
    this.height = restaurantCoverHeightSm,
    this.hasBorderRadius = true,
    this.hasRating = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(hasBorderRadius ? 8 : 0),
                border: hasBorderRadius ? Border.all(color: AppColors.border, width: 0.5) : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(hasBorderRadius ? 8 : 0),
                child: AppCachedNetworkImage(
                  imageUrl: restaurant.chain.media.cover,
                  fit: BoxFit.cover,
                  color: AppColors.primary.withOpacity(0.2),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: restaurant.discountValue != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // if (restaurant.discountValue != null) DiscountTag(value: restaurant.discountValue),
                    RestaurantFavoriteButton(restaurantId: restaurant.id),
                  ],
                ),
                if (restaurant.rating.averageRaw > 0 && restaurant.rating.countRaw > 0 && hasRating)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: AppColors.white,
                        ),
                        child: restaurant.rating.countRaw < 10
                            ? Text(Translations.of(context).get("New"), style: AppTextStyles.subtitleSecondary)
                            : RatingInfo(
                                hasWhiteBg: true,
                                ratingValue: restaurant.rating.averageRaw,
                                ratingsCount: restaurant.rating.countRaw,
                              ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
