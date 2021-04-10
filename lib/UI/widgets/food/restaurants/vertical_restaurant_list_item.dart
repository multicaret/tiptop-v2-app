import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/food/delivery_info.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_cover_with_info.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class VerticalRestaurantListItem extends StatelessWidget {
  final Branch restaurant;

  VerticalRestaurantListItem({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RestaurantCoverWithInfo(restaurant: restaurant),
          const SizedBox(height: 10),
          Text(restaurant.title),
          const SizedBox(height: 10),
          Row(
            children: [
              if (restaurant.tiptopDelivery.isDeliveryEnabled)
                Expanded(
                  child: DeliveryInfo(
                    restaurantDelivery: restaurant.tiptopDelivery,
                    hasDeliveryFeeItem: false,
                  ),
                ),
              if (restaurant.restaurantDelivery.isDeliveryEnabled)
                Expanded(
                  child: DeliveryInfo(
                    restaurantDelivery: restaurant.restaurantDelivery,
                    hasDeliveryFeeItem: false,
                    isRestaurant: true,
                  ),
                ),
              //Make the remaining delivery method fit half the screen
              if (!restaurant.tiptopDelivery.isDeliveryEnabled || !restaurant.restaurantDelivery.isDeliveryEnabled) Expanded(child: Container())
            ],
          ),
        ],
      ),
    );
  }
}
