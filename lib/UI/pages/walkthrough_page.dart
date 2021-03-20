import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_step_one_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'package:tiptop_v2/UI/app_wrapper.dart';

class WalkthroughPage extends StatelessWidget {
  static const routeName = '/walkthrough';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AppScaffold(
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
                GestureDetector(
                  onTap: () {
                    getLocationPermissionStatus().then((isGranted) {
                      Navigator.of(context).pushReplacementNamed(isGranted ? AppWrapper.routeName : LocationPermissionPage.routeName);
                    });
                  },
                  child: Text(
                    Translations.of(context).get('Continue Without Login'),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(OTPStepOnePage.routeName);
                  },
                  child: Text(Translations.of(context).get('Register')),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Translations.of(context).get('Already have an account?')),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(OTPStepOnePage.routeName);
                      },
                      child: Text(
                        Translations.of(context).get('Login'),
                        style: AppTextStyles.bodySecondaryDark,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
