import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class LocationPermissionDialog extends StatelessWidget {
  final Function action;

  LocationPermissionDialog({this.action});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: AppColors.white,
      contentPadding: EdgeInsets.all(0),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
            ElevatedButton(
              onPressed: action,
              child: Text(Translations.of(context).get('Go to Settings')),
            ),
          ],
        ),
      ),
    );
  }
}
