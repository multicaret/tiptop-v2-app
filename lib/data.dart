import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import 'UI/pages/otp/otp_step_three_page.dart';

List<Map<String, dynamic>> getVerificationMethods(BuildContext context) {
  return [
    {
      'name': 'WhatsApp',
      'color': AppColors.whatsApp,
      'icon': FontAwesomeIcons.whatsapp,
      'action': () {},
    },
    {
      'name': 'Telegram',
      'color': AppColors.telegram,
      'icon': FontAwesomeIcons.telegram,
      'action': () {},
    },
    {
      'name': 'SMS',
      'color': AppColors.primary,
      'icon': FontAwesomeIcons.sms,
      'action': () {
        Navigator.of(context).pushNamed(OTPStepThreePage.routeName);
      },
    },
  ];
}
