import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'app_alert_dialog.dart';

class ConfirmAlertDialog extends StatelessWidget {
  final String title;
  final String image;
  final bool hasTextField;
  final String textFieldHint;
  final TextEditingController controller;

  ConfirmAlertDialog({
    this.title,
    this.image,
    this.hasTextField = false,
    this.textFieldHint,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      children: [
        SizedBox(height: 20),
        if (image != null)
          Padding(
            padding: EdgeInsets.only(left: 100, right: 100, bottom: 20),
            child: Image(
              image: AssetImage(image),
            ),
          ),
        hasTextField
            ? AppTextField(
                controller: controller,
                hintText: Translations.of(context).get(textFieldHint),
                hasInnerLabel: true,
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  Translations.of(context).get(title),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyBold.copyWith(height: 1.4),
                ),
              ),
        SizedBox(height: hasTextField ? 0 : 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppColors.secondaryDark,
                  minimumSize: Size.fromHeight(45),
                ),
                child: Text(Translations.of(context).get(hasTextField ? 'Done' : 'Yes')),
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
                child: Text(Translations.of(context).get(hasTextField ? 'Cancel' : 'No')),
              ),
            )
          ],
        )
      ],
    );
  }
}
