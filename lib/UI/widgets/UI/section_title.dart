import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final String suffix;
  final bool translate;
  final TextStyle suffixTextStyle;

  SectionTitle(this.text, {this.suffix, this.translate = true, this.suffixTextStyle = AppTextStyles.body50});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: screenHorizontalPadding, left: screenHorizontalPadding, top: 30, bottom: 5),
      margin: const EdgeInsets.only(bottom: 8),
      color: AppColors.bg,
      child: RichText(
        text: TextSpan(
          text: translate ? Translations.of(context).get(text) : text,
          style: DefaultTextStyle.of(context).style.copyWith(color: AppColors.text50, fontSize: 14),
          children: <TextSpan>[
            if (suffix != null && suffix.isNotEmpty) TextSpan(text: suffix, style: suffixTextStyle),
          ],
        ),
      ),
    );
  }
}
