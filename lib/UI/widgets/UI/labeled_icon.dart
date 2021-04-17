import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class LabeledIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final bool isLast;
  final bool isIconLarge;

  LabeledIcon({
    @required this.icon,
    this.color = AppColors.primary50,
    this.text,
    this.isLast = false,
    this.isIconLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isLast ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isIconLarge ? AppIcons.icon50(icon) : AppIcons.iconXs50(icon),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: isIconLarge ? AppTextStyles.body50 : AppTextStyles.subtitle50,
          ),
        ),
      ],
    );
  }
}
