import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'app_alert_dialog.dart';

class ConfirmAlertDialog extends StatelessWidget {
  final String title;
  final String image;

  ConfirmAlertDialog({
    this.title,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      children: [
        const SizedBox(height: 20),
        if (image != null)
          Padding(
            padding: const EdgeInsets.only(left: 100, right: 100, bottom: 20),
            child: Image(
              image: AssetImage(image),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            Translations.of(context).get(title),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBold.copyWith(height: 1.4),
          ),
        ),
      ],
      actions: [
        DialogAction(
          text: 'Yes',
          buttonColor: AppColors.secondary,
          popValue: true,
        ),
        DialogAction(
          text: 'No',
          popValue: false,
        ),
      ],
    );
  }
}
