import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_step_two_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/helper.dart';

class OTPStepOnePage extends StatelessWidget {
  static const routeName = '/otp-step-one';
  final GlobalKey<FormState> _formKey = GlobalKey();

  static String phoneCountryCode = '';
  static String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
            ElevatedButton(
              onPressed: () => _submit(context),
              child: Text(Translations.of(context).get('Continue')),
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
    Navigator.of(context).pushNamed(OTPStepTwoPage.routeName, arguments: {
      'phone_number': phoneNumber,
      'phone_country_code': phoneCountryCode,
    });
  }
}
