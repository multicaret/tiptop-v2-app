import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'app_alert_dialog.dart';

class LocationPermissionDialog extends StatelessWidget {
  final Function action;

  LocationPermissionDialog({this.action});

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      children: [
        SizedBox(height: 20),
        Text(
          Translations.of(context).get('Location Permission'),
          style: AppTextStyles.bodyBold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          Translations.of(context).get('Location services must be turned on in order to use the app'),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        AppButtons.primary(
          onPressed: action,
          child: Text(Translations.of(context).get('Go to Settings')),
        ),
      ],
    );
  }
}
