import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final String suffix;
  final bool translate;

  SectionTitle(this.text, {this.suffix, this.translate = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: screenHorizontalPadding, left: screenHorizontalPadding, top: 30, bottom: 5),
      color: AppColors.bg,
      child: Text(
        '${translate ? Translations.of(context).get(text) : text}${suffix ?? ''}',
        style: AppTextStyles.body50,
      ),
    );
  }
}
