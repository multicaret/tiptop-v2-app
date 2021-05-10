import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import '../UI/labeled_icon.dart';
import '../UI/section_title.dart';

class FoodCheckoutDeliveryOptions extends StatelessWidget {
  final Branch restaurant;
  final RestaurantDeliveryType selectedDeliveryType;
  final Function selectDeliveryType;
  final double cartTotal;

  FoodCheckoutDeliveryOptions({
    @required this.restaurant,
    @required this.selectedDeliveryType,
    @required this.selectDeliveryType,
    @required this.cartTotal,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> getDeliveryOptionInfoItems(BranchDelivery delivery, Currency currency) {
      double deliveryFee = calculateDeliveryFee(delivery: delivery, cartTotal: cartTotal);
      List<Map<String, dynamic>> items = [
        {
          'title': 'Time',
          'icon': LineAwesomeIcons.hourglass,
          'value': '${delivery.minDeliveryMinutes}-${delivery.maxDeliveryMinutes} min',
        },
        {
          'title': 'Delivery Fee',
          'icon': LineAwesomeIcons.truck_moving,
          'value': deliveryFee == 0 ? Translations.of(context).get("Free") : priceAndCurrency(deliveryFee, currency),
        }
      ];
      if (delivery.underMinimumOrderDeliveryFee.raw == 0) {
        items.add({
          'title': 'Min. Cart',
          'icon': LineAwesomeIcons.shopping_basket,
          'value': delivery.minimumOrder.formatted,
        });
      }
      return items;
    }

    return Consumer2<HomeProvider, AppProvider>(
      builder: (c, homeProvider, appProvider, _) => Column(
        children: [
          SectionTitle('Delivery Options'),
          if (restaurant.tiptopDelivery.isDeliveryEnabled)
            deliveryOptionRadioItem(
              context: context,
              isRTL: appProvider.isRTL,
              title: appProvider.isRTL
                  ? Row(
                      children: [
                        Text(Translations.of(context).get("Delivery")),
                        const SizedBox(width: 5),
                        Image(
                          image: AssetImage('assets/images/tiptop-logo-title-yellow.png'),
                          width: 60,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Image(
                          image: AssetImage('assets/images/tiptop-logo-title-yellow.png'),
                          width: 60,
                        ),
                        const SizedBox(width: 5),
                        Text(Translations.of(context).get("Delivery")),
                      ],
                    ),
              isDisabled: restaurant.tiptopDelivery.underMinimumOrderDeliveryFee.raw == 0 && cartTotal < restaurant.tiptopDelivery.minimumOrder.raw,
              delivery: restaurant.tiptopDelivery,
              deliveryInfoItems: getDeliveryOptionInfoItems(restaurant.tiptopDelivery, homeProvider.foodCurrency),
              deliveryType: RestaurantDeliveryType.TIPTOP,
            ),
          if (restaurant.restaurantDelivery.isDeliveryEnabled)
            deliveryOptionRadioItem(
              context: context,
              isRTL: appProvider.isRTL,
              title: "Restaurant Delivery",
              isDisabled:
                  restaurant.restaurantDelivery.underMinimumOrderDeliveryFee.raw == 0 && cartTotal < restaurant.restaurantDelivery.minimumOrder.raw,
              delivery: restaurant.restaurantDelivery,
              deliveryInfoItems: getDeliveryOptionInfoItems(restaurant.restaurantDelivery, homeProvider.foodCurrency),
              deliveryType: RestaurantDeliveryType.RESTAURANT,
            ),
        ],
      ),
    );
  }

  Widget deliveryOptionRadioItem({
    BuildContext context,
    dynamic title,
    List<Map<String, dynamic>> deliveryInfoItems,
    BranchDelivery delivery,
    RestaurantDeliveryType deliveryType,
    bool isDisabled = false,
    @required bool isRTL,
  }) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: Material(
        color: AppColors.white,
        child: InkWell(
          onTap: () {
            if (isDisabled) {
              showToast(
                msg: Translations.of(context).get(
                  "Your cart total should be greater than: {minimumOrder}",
                  args: [delivery.minimumOrder.formatted],
                ),
              );
              return;
            }
            selectDeliveryType(deliveryType);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: isRTL ? screenHorizontalPadding : 7,
              right: isRTL ? 7 : screenHorizontalPadding,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio(
                  value: deliveryType,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  groupValue: selectedDeliveryType,
                  onChanged: isDisabled ? null : (value) => selectDeliveryType(value),
                  activeColor: AppColors.secondary,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title is Widget ? title : Text(Translations.of(context).get(title)),
                      const SizedBox(height: 10),
                      Column(
                        children: List.generate(deliveryInfoItems.length, (i) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: i < deliveryInfoItems.length - 1 ? 10 : 0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: LabeledIcon(
                                    isIconLarge: true,
                                    icon: deliveryInfoItems[i]['icon'],
                                    text: Translations.of(context).get(deliveryInfoItems[i]['title']),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    deliveryInfoItems[i]['value'],
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
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
