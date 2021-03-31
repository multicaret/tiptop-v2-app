import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class LabeledIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final bool isLast;

  LabeledIcon({
    @required this.icon,
    this.color = AppColors.primary50,
    this.text,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isLast ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        AppIcon.iconXs50(icon),
        SizedBox(width: 5),
        Text(
          text,
          style: AppTextStyles.subtitle50,
        ),
      ],
    );
  }
}
