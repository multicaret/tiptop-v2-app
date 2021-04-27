import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class DiscountTag extends StatelessWidget {
  final String value;

  DiscountTag({@required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 25,
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: AppColors.secondary,
      ),
      child: Row(
        children: [
          AppIcons.iconSm(FontAwesomeIcons.tag),
          const SizedBox(width: 5.0),
          Expanded(
            child: Text(
              '$value ${Translations.of(context).get("discount")}',
              style: AppTextStyles.subtitle,
            ),
          ),
        ],
      ),
    );
  }
}
