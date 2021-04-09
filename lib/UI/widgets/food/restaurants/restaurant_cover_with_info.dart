import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/rating_info.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_favorite_button.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class RestaurantCoverWithInfo extends StatelessWidget {
  final Branch restaurant;
  final Function favoriteAction;
  final double height;
  final bool hasBorderRadius;

  const RestaurantCoverWithInfo({
    @required this.restaurant,
    this.favoriteAction,
    this.height = 180,
    this.hasBorderRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(hasBorderRadius ? 8 : 0),
        border: hasBorderRadius ? Border.all(color: AppColors.border, width: 0.5) : null,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(restaurant.chain.media.cover),
        ),
      ),
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
              RestaurantFavoriteButton(restaurantId: restaurant.id, isFavorited: restaurant.isFavorited),
            ],
          ),
          if (restaurant.rating.averageRaw > 0 && restaurant.rating.countRaw > 0)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: AppColors.white,
                  ),
                  child: RatingInfo(
                    hasWhiteBg: true,
                    ratingValue: restaurant.rating.averageRaw,
                    ratingsCount: restaurant.rating.countRaw,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
