import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ApplyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 17, right: 17, bottom: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: AppColors.secondaryDark),
        child: Text(Translations.of(context).get('Apply'), style: AppTextStyles.body),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
