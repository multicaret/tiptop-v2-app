import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

import 'UI/input/app_rating_bar.dart';
import 'UI/section_title.dart';

class OrderRatingButton extends StatelessWidget {
  final Order order;
  final Function onTap;
  final bool isRTL;

  OrderRatingButton({
    @required this.order,
    @required this.onTap,
    @required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(order.orderRating.branchHasBeenRated ? 'Thanks for your rating' : 'Please Rate Your Experience'),
        Material(
          color: AppColors.white,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppRatingBar(
                    disabled: true,
                    initialRating: order.orderRating.branchRatingValue ?? 0,
                  ),
                  if (!order.orderRating.branchHasBeenRated) AppIcons.icon(isRTL ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
