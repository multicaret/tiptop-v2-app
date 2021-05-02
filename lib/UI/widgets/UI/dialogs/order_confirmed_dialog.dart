import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/app_alert_dialog.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class OrderConfirmedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            '🤩',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          Translations.of(context).get("Order Received"),
          style: AppTextStyles.bodyBold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            Translations.of(context).get("You can track your order live on the map"),
            textAlign: TextAlign.center,
          ),
        ),
      ],
      actions: [
        DialogAction(
          text: 'Done',
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
