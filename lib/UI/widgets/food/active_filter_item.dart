import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.subtitleXs,
          ),
          if (closeAction != null) SizedBox(width: 5),
          if (closeAction != null)
            GestureDetector(
              onTap: closeAction,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  FontAwesomeIcons.times,
                  color: AppColors.primaryLight,
                  size: 12,
                ),
              ),
            )
        ],
      ),
    );
  }
}
