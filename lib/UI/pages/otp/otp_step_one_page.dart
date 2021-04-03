import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_step_two_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class OTPStepOnePage extends StatelessWidget {
  static const routeName = '/otp-step-one';
  final GlobalKey<FormState> _formKey = GlobalKey();

  static String phoneCountryCode = '';
  static String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bgColor: AppColors.white,
      bgImage: "assets/images/page-bg-pattern-white.png",
      bodyPadding: EdgeInsets.symmetric(horizontal: 17.0),
      body: Form(
        key: _formKey,
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
                    required: true,
                    textDirection: TextDirection.ltr,
                    labelText: 'Country Code',
                    hintText: '+(964)',
                    initialValue: '+90',
                    prefixIcon: Image.asset(
                      'assets/images/sa-flag.png',
                      width: 20,
                    ),
                    onSaved: (value) {
                      phoneCountryCode = value;
                    },
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  flex: 5,
                  child: AppTextField(
                    required: true,
                    textDirection: TextDirection.ltr,
                    labelText: 'Phone Number',
                    initialValue: '5070326662',
                    hintText: '5xx-xxx-xx-xx',
                    onSaved: (value) {
                      phoneNumber = value;
                    },
                  ),
                ),
              ],
            ),
            AppButtons.primary(
              onPressed: () => _submit(context),
              child: Text(Translations.of(context).get('Continue')),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(AppWrapper.routeName);
              },
              child: Text(Translations.of(context).get('Continue Without Login')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      showToast(msg: Translations.of(context).get('Invalid Form'));
      return;
    }
    _formKey.currentState.save();
    Navigator.of(context).pushReplacementNamed(OTPStepTwoPage.routeName, arguments: {
      'phone_number': phoneNumber,
      'phone_country_code': phoneCountryCode,
    });
  }
}
