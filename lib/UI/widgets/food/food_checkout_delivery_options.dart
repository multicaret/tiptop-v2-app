import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import '../UI/labeled_icon.dart';
import '../UI/section_title.dart';

class FoodCheckoutDeliveryOptions extends StatelessWidget {
  final Branch restaurant;

  FoodCheckoutDeliveryOptions({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    //Todo: Continue refactoring this widget and add restaurant delivery option (if enabled) and activate radio selection
    List<Map<String, dynamic>> getDeliveryOptionInfoItems(BranchDelivery delivery) {
      return [
        {
          'title': 'Time',
          'icon': LineAwesomeIcons.hourglass,
          'value': '${delivery.minDeliveryMinutes}-${delivery.maxDeliveryMinutes} min',
        },
        {
          'title': 'Delivery Fee',
          'icon': LineAwesomeIcons.truck_moving,
          'value': delivery.fixedDeliveryFee.formatted,
        },
        {
          'title': 'Min. Cart',
          'icon': LineAwesomeIcons.shopping_basket,
          'value': delivery.minimumOrder.formatted,
        }
      ];
    }

    List<Map<String, dynamic>> tiptopDeliveryInfoItems = getDeliveryOptionInfoItems(restaurant.tiptopDelivery);
    List<Map<String, dynamic>> restaurantDeliveryInfoItems = getDeliveryOptionInfoItems(restaurant.restaurantDelivery);

    return Column(
      children: [
        SectionTitle('Delivery Options'),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
            color: AppColors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio(
                value: 1,
                groupValue: 1,
                onChanged: (_) {},
                activeColor: AppColors.secondary,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 17),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image(
                            image: AssetImage('assets/images/tiptop-logo-title-yellow.png'),
                            width: 60,
                          ),
                          const SizedBox(width: 5),
                          Text(Translations.of(context).get('Delivery')),
                        ],
                      ),
                      Column(
                        children: List.generate(tiptopDeliveryInfoItems.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: LabeledIcon(
                                    isIconLarge: true,
                                    icon: tiptopDeliveryInfoItems[i]['icon'],
                                    text: Translations.of(context).get(tiptopDeliveryInfoItems[i]['title']),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    tiptopDeliveryInfoItems[i]['value'],
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
