import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CircleIcon extends StatelessWidget {
  final Color bgColor;
  final Color iconColor;
  final String iconImage;
  final String iconText;
  final TextStyle iconTextStyle;
  final IconData iconData;
  final double size;

  CircleIcon({
    this.bgColor = AppColors.primary,
    this.iconColor = AppColors.secondary,
    this.iconImage,
    this.iconData,
    this.size = 18,
    this.iconText,
    this.iconTextStyle = AppTextStyles.subtitleXxsSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: iconData != null
          ? Icon(
              iconData,
              color: AppColors.secondary,
              size: 10,
            )
          : iconText != null
              ? Center(
                  child: Text(
                    iconText,
                    style: iconTextStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              : Image.asset(
                  iconImage,
                ),
    );
  }
}
