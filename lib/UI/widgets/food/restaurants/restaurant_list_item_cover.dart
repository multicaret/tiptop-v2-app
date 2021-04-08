import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/UI/discount_tag.dart';
import 'package:tiptop_v2/UI/widgets/UI/rating_info.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class RestaurantListItemCover extends StatelessWidget {
  final Branch restaurant;
  final Function favoriteAction;
  final bool isFavorited;
  final bool hasRating;
  final double height;
  final bool hasBorderRadius;

  const RestaurantListItemCover({
    @required this.restaurant,
    this.favoriteAction,
    this.isFavorited,
    this.hasRating = true,
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
              GestureDetector(
                onTap: favoriteAction,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      const BoxShadow(blurRadius: 6, color: AppColors.shadowDark),
                    ],
                  ),
                  child: AppIcons.iconMdSecondary(isFavorited ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart),
                ),
              )
            ],
          ),
          if(hasRating)
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
                  ratingValue: 3.5,
                  ratingsCount: 250,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
