import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ProductOptionPill extends StatelessWidget {
  final String text;
  final bool isExcluding;
  final bool isActive;
  final Function onTap;
  final DoubleRawStringFormatted price;

  const ProductOptionPill({
    @required this.text,
    this.isExcluding = false,
    this.isActive = false,
    @required this.onTap,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isExcluding && isActive ? AppColors.border.withOpacity(0.2) : AppColors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isExcluding
                ? Border.all(color: isActive ? AppColors.border : AppColors.primary)
                : Border.all(color: isActive ? AppColors.primary : AppColors.border),
          ),
          child: RichText(
            text: TextSpan(
              text: text,
              style: isExcluding
                  ? AppTextStyles.subtitle.copyWith(
                      color: isActive ? AppColors.border : AppColors.primary,
                      decoration: isActive ? TextDecoration.lineThrough : null,
                    )
                  : AppTextStyles.subtitle.copyWith(
                      color: isActive ? AppColors.primary : AppColors.border,
                    ),
              children: <TextSpan>[
                if (price != null && price.raw > 0)
                  TextSpan(
                    text: ' [+${price.formatted}]',
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.secondary.withOpacity(isActive ? 1 : 0.5),
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
