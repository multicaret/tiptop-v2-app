import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'app_alert_dialog.dart';

class ConfirmAlertDialog extends StatelessWidget {
  final String title;

  ConfirmAlertDialog({
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            Translations.of(context).get(title),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBold,
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppColors.secondaryDark,
                  minimumSize: Size.fromHeight(45),
                ),
                child: Text(Translations.of(context).get('Yes')),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(45),
                ),
                child: Text(Translations.of(context).get('No')),
              ),
            )
          ],
        )
      ],
    );
  }
}
