import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/UI/discount_tag.dart';
import 'package:tiptop_v2/UI/widgets/UI/rating_info.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';

class RestaurantListItemCover extends StatelessWidget {
  final Restaurant restaurant;
  final Function favoriteAction;
  final bool isFavorited;

  const RestaurantListItemCover({
    @required this.restaurant,
    this.favoriteAction,
    this.isFavorited,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(restaurant.cover),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: restaurant.discountValue != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (restaurant.discountValue != null) DiscountTag(value: restaurant.discountValue),
              GestureDetector(
                onTap: favoriteAction,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(blurRadius: 6, color: AppColors.shadowDark),
                    ],
                  ),
                  child: AppIcon.iconMdSecondary(isFavorited ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
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
