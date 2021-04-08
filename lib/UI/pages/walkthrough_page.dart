import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_choose_method_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'package:tiptop_v2/UI/app_wrapper.dart';

class WalkthroughPage extends StatelessWidget {
  static const routeName = '/walkthrough';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AppScaffold(
      bodyPadding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
      bgColor: AppColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'assets/images/tiptop-logo.png',
            width: screenSize.width / 2.5,
          ),
          Container(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    getLocationPermissionStatus().then((isGranted) {
                      Navigator.of(context).pushReplacementNamed(isGranted ? AppWrapper.routeName : LocationPermissionPage.routeName);
                    });
                  },
                  child: Text(
                    Translations.of(context).get('Continue Without Login'),
                  ),
                ),
                const SizedBox(height: 40),
                AppButtons.primary(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(OTPChooseMethodPage.routeName);
                  },
                  child: Text(Translations.of(context).get('Register')),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(OTPChooseMethodPage.routeName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Translations.of(context).get('Already have an account?')),
                      const SizedBox(width: 5),
                      Text(
                        Translations.of(context).get('Login'),
                        style: AppTextStyles.bodySecondaryDark,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
