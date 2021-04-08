import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tiptop_v2/UI/widgets/UI/rating_info.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_list_item_cover.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../delivery_info.dart';

class RestaurantHeaderInfo extends StatelessWidget {
  final Branch restaurant;

  RestaurantHeaderInfo({this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            RestaurantListItemCover(
              restaurant: restaurant,
              isFavorited: false,
              hasRating: false,
              hasBorderRadius: false,
              height: restaurantCoverHeight,
            ),
            Positioned(
              bottom: 0,
              right: screenHorizontalPadding,
              left: screenHorizontalPadding,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 100),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(8),
                          topRight: const Radius.circular(8),
                        ),
                        boxShadow: [const BoxShadow(blurRadius: 6, color: AppColors.shadow)],
                      ),
                      padding: const EdgeInsets.only(left: 130, top: 20, bottom: 20, right: 15),
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.title,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${Translations.of(context).get('Closes at')} ${restaurant.workingHours.closesAt}',
                                  maxLines: 1,
                                  style: AppTextStyles.subtitle50,
                                ),
                              ),
                              RatingInfo(
                                ratingValue: 4.5,
                                ratingsCount: 350,
                                hasWhiteBg: true,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 15,
                      height: restaurantLogoSize,
                      width: restaurantLogoSize,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [const BoxShadow(color: AppColors.shadow, blurRadius: 6)],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: CachedNetworkImage(
                          imageUrl: restaurant.chain.media.logo,
                          placeholder: (_, __) => SpinKitFadingCircle(
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: screenHorizontalPadding,
              right: screenHorizontalPadding,
              bottom: sliverAppBarSearchBarHeight + 5,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: const Radius.circular(8),
                bottomRight: const Radius.circular(8),
              ),
              boxShadow: [
                const BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 3)),
              ],
            ),
            child: Column(
              children: [
                if (restaurant.tiptopDelivery.isDeliveryEnabled) DeliveryInfo(restaurantDelivery: restaurant.tiptopDelivery),
                const SizedBox(height: 10),
                if (restaurant.restaurantDelivery.isDeliveryEnabled)
                  DeliveryInfo(restaurantDelivery: restaurant.restaurantDelivery, isRestaurant: true),
              ],
            ),
          ),
        )
      ],
    );
  }
}
