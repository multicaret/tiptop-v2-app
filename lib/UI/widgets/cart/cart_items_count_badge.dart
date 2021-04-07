import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CartItemsCountBadge extends StatelessWidget {
  final int count;

  CartItemsCountBadge({@required this.count});

  @override
  Widget build(BuildContext context) {
    return count == 0
        ? Container()
        : Container(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: count.toString().length > 1 ? AppTextStyles.subtitleXsBold : AppTextStyles.subtitleBold,
              ),
            ),
          );
  }
}
