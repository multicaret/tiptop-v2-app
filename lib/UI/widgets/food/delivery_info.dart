import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/UI/circle_icon.dart';
import 'package:tiptop_v2/UI/widgets/UI/labeled_icon.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class DeliveryInfo extends StatelessWidget {
  final BranchDelivery restaurantDelivery;
  final bool isRestaurant;
  final bool hasDeliveryFeeItem;

  DeliveryInfo({
    @required this.restaurantDelivery,
    this.isRestaurant = false,
    this.hasDeliveryFeeItem = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      // height: 50,
      child: Column(
        children: [
          Row(
            children: [
              isRestaurant ? CircleIcon(iconText: 'R') : CircleIcon(iconImage: 'assets/images/logo-man-only.png'),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Text(
                  Translations.of(context).get(isRestaurant ? "Restaurant Delivery" : "TipTop Delivery"),
                  style: AppTextStyles.subtitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: LabeledIcon(
                  icon: LineAwesomeIcons.hourglass,
                  text: '${restaurantDelivery.minDeliveryMinutes}-${restaurantDelivery.maxDeliveryMinutes}',
                ),
              ),
              if(hasDeliveryFeeItem)
              Expanded(
                child: LabeledIcon(
                  icon: LineAwesomeIcons.truck_moving,
                  text: restaurantDelivery.fixedDeliveryFee.formatted,
                ),
              ),
              Expanded(
                child: LabeledIcon(
                  icon: LineAwesomeIcons.shopping_basket,
                  text: restaurantDelivery.minimumOrder.formatted,
                  isLast: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
