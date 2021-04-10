import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ActiveFilterItem extends StatelessWidget {
  final Function closeAction;
  final String title;

  ActiveFilterItem({
    @required this.closeAction,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: AppTextStyles.subtitleXs,
      ),
    );
  }
}
