import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/UI/circle_icon.dart';
import 'package:tiptop_v2/UI/widgets/UI/labeled_icon.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class DeliveryInfo extends StatelessWidget {
  final bool isRestaurant;

  DeliveryInfo({this.isRestaurant = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            isRestaurant ? CircleIcon(iconText: 'R') : CircleIcon(iconImage: 'assets/images/logo-man-only.png'),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Text(
                Translations.of(context).get(isRestaurant ? "Restaurant delivery" : "TipTop delivery"),
                style: AppTextStyles.subtitle,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: LabeledIcon(
                icon: FontAwesomeIcons.hourglassHalf,
                text: '15-20',
              ),
            ),
            Expanded(
              child: LabeledIcon(
                icon: FontAwesomeIcons.shoppingBasket,
                text: '25 IQD',
              ),
            ),
            Expanded(
              child: LabeledIcon(
                icon: FontAwesomeIcons.shoppingBasket,
                text: 'Min. 1000 IQD',
                isLast: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
