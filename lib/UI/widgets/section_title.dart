import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final String suffix;

  SectionTitle(this.text, {this.suffix});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 17, left: 17, top: 30, bottom: 5),
      color: AppColors.bg,
      child: Text(
        '${Translations.of(context).get(text)}${suffix ?? ''}',
        style: AppTextStyles.body50,
      ),
    );
  }
}
