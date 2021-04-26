import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FoodCartControls extends StatelessWidget {
  final int quantity;
  final Function action;
  final bool isMin;

  FoodCartControls({
    @required this.quantity,
    @required this.action,
    this.isMin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeightSm,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Remove button
          Expanded(
            child: InkWell(
              onTap: () => action(CartAction.REMOVE),
              child: Container(
                child: Icon(
                  FontAwesomeIcons.minus,
                  color: AppColors.white,
                  size: isMin ? 14 : 20,
                ),
              ),
            ),
          ),
          //Quantity
          Expanded(
            child: Container(
              color: AppColors.white,
              alignment: Alignment.center,
              child: Text(
                '$quantity',
                style: isMin
                    ? quantity.toString().length >= 2
                        ? AppTextStyles.subtitleXsBold
                        : AppTextStyles.subtitleBold
                    : AppTextStyles.bodyBold,
              ),
            ),
          ),
          //Add button
          Expanded(
            child: InkWell(
              onTap: () => action(CartAction.ADD),
              child: Container(
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: AppColors.white,
                  size: isMin ? 14 : 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
