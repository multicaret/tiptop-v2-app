import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class OrderInfo extends StatelessWidget {
  final Order order;

  OrderInfo({@required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Translations.of(context).get("Reference Code"), style: AppTextStyles.body50),
              Text('${order.referenceCode}'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Translations.of(context).get("Status"), style: AppTextStyles.body50),
              Text(Translations.of(context).get(orderStatusStringValues.reverse[order.status])),
            ],
          ),
        ],
      ),
    );
  }
}
