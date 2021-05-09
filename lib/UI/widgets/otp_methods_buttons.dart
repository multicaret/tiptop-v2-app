import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class OTPMethodsButtons extends StatelessWidget {
  final Function initOTPAction;
  final bool isRTL;

  OTPMethodsButtons({
    @required this.initOTPAction,
    @required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _verificationMethods = [
      {
        'id': 'whatsapp',
        'name': 'WhatsApp',
        'color': AppColors.whatsApp,
        'icon': FontAwesomeIcons.whatsapp,
      },
      {
        'id': 'telegram',
        'name': 'Telegram',
        'color': AppColors.telegram,
        'icon': FontAwesomeIcons.telegram,
      },
      {
        'id': 'sms',
        'name': 'SMS',
        'color': AppColors.primary,
        'icon': FontAwesomeIcons.sms,
      },
    ];

    return Column(
      children: [
        Text(
          Translations.of(context).get("Please choose preferred method"),
          style: AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ...List.generate(_verificationMethods.length, (i) {
          return Container(
            padding: EdgeInsets.only(bottom: i == _verificationMethods.length - 1 ? 0 : 20),
            child: AppButtons.dynamic(
              onPressed: () => initOTPAction(_verificationMethods[i]['id']),
              bgColor: _verificationMethods[i]['color'],
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
                      child: Icon(_verificationMethods[i]['icon']),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "${Translations.of(context).get("Continue Via")} ${_verificationMethods[i]['name']}",
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
