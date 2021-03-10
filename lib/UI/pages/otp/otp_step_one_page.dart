import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_step_two_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';

class OTPStepOnePage extends StatelessWidget {
  static const routeName = '/otp-step-one';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bgImage: 'assets/images/otp-bg-pattern.png',
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(Translations.of(context).get('Please Enter Your Phone Number')),
            SizedBox(height: 50),
            Row(
              textDirection: TextDirection.ltr,
              children: [
                Expanded(
                  flex: 3,
                  child: AppTextField(
                    textDirection: TextDirection.ltr,
                    labelText: 'Country Code',
                    hintText: '+(964)',
                    prefixIcon: Image.asset(
                      'assets/images/sa-flag.png',
                      width: 20,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  flex: 5,
                  child: AppTextField(
                    textDirection: TextDirection.ltr,
                    labelText: 'Phone Number',
                    hintText: '5xx-xxx-xx-xx',
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(OTPStepTwoPage.routeName);
              },
              child: Text(Translations.of(context).get('Continue')),
            ),
          ],
        ),
      ),
    );
  }
}
