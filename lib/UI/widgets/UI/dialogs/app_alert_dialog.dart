import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AppAlertDialog extends StatelessWidget {
  final List<Widget> children;
  final List<DialogAction> actions;

  AppAlertDialog({
    @required this.children,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: AppColors.white,
      contentPadding: EdgeInsets.all(10),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...children,
            if (actions != null && actions.length > 0) SizedBox(height: 20),
            if (actions != null && actions.length > 0)
              Row(
                children: List.generate(
                  actions.length,
                  (i) => Expanded(
                    child: Padding(
                      padding: i < actions.length - 1
                          ? EdgeInsets.only(right: appProvider.isRTL ? 0 : 16, left: appProvider.isRTL ? 16 : 0)
                          : EdgeInsets.all(0),
                      child: AppButtons.dynamic(
                        bgColor: actions[i].buttonColor,
                        textColor: actions[i].buttonTextColor,
                        height: 45,
                        child: Text(Translations.of(context).get(actions[i].text)),
                        onPressed: actions[i].onTap ??
                            () {
                              Navigator.of(context).pop(actions[i].popValue);
                            },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
