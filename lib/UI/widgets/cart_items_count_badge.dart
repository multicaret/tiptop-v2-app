import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CartItemsCountBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.secondaryDark,
          shape: BoxShape.circle,
        ),
        child: Text(
          '2',
          style: AppTextStyles.bodyBold,
        ),
      ),
    );
  }
}
