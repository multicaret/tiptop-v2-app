import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_cached_network_image.dart';
import 'package:tiptop_v2/UI/widgets/UI/rating_info.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_cover_with_info.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/branch.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../delivery_info.dart';

class RestaurantHeaderInfo extends StatelessWidget {
  final Branch restaurant;
  final bool coverHasRating;

  RestaurantHeaderInfo({this.restaurant, this.coverHasRating = true});

  String getScheduleMessage(BuildContext context) {
    return restaurant.workingHours.isOpen
        ? '${Translations.of(context).get("Closes at")} ${restaurant.workingHours.closesAt}'
        : Translations.of(context).get("Closed");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            RestaurantCoverWithInfo(
              restaurant: restaurant,
              hasBorderRadius: false,
              height: restaurantCoverHeight,
              hasRating: coverHasRating,
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
                child: Consumer<AppProvider>(
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
                              getScheduleMessage(context),
                              maxLines: 1,
                              style: AppTextStyles.subtitle50,
                            ),
                          ),
                          if (restaurant.rating.averageRaw > 0 && restaurant.rating.countRaw > 0)
                            restaurant.rating.countRaw < 10
                                ? Text(
                                    Translations.of(context).get("New"),
                                    style: AppTextStyles.subtitleSecondary,
                                  )
                                : RatingInfo(
                                    ratingValue: restaurant.rating.averageRaw,
                                    ratingsCount: restaurant.rating.countRaw,
                                    hasWhiteBg: true,
                                  ),
                        ],
                      )
                    ],
                  ),
                  builder: (c, appProvider, child) => Stack(
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
                        padding: EdgeInsets.only(left: appProvider.isRTL ? 15 : 130, right: appProvider.isRTL ? 130 : 15, top: 20, bottom: 20),
                        margin: EdgeInsets.only(top: 20),
                        child: child,
                      ),
                      Positioned(
                        bottom: 20,
                        left: appProvider.isRTL ? null : 15,
                        right: appProvider.isRTL ? 15 : null,
                        height: restaurantLogoSize,
                        width: restaurantLogoSize,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [const BoxShadow(color: AppColors.shadow, blurRadius: 6)],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: AppCachedNetworkImage(
                            imageUrl: restaurant.chain.media.logo,
                          ),
                        ),
                      )
                    ],
                  ),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (restaurant.tiptopDelivery.isDeliveryEnabled) DeliveryInfo(delivery: restaurant.tiptopDelivery),
                const SizedBox(height: 10),
                if (restaurant.restaurantDelivery.isDeliveryEnabled) DeliveryInfo(delivery: restaurant.restaurantDelivery, isRestaurant: true),
              ],
            ),
          ),
        )
      ],
    );
  }
}
