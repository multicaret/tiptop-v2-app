import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_complete_profile_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_pin_code_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/otp_provider.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class OTPStepThreePage extends StatefulWidget {
  static const routeName = '/otp-step-three';

  @override
  _OTPStepThreePageState createState() => _OTPStepThreePageState();
}

class _OTPStepThreePageState extends State<OTPStepThreePage> {
  OTPProvider otpProvider;
  bool _isInit = true;
  String reference;
  String phoneCountryCode;
  String phoneNumber;
  String countryCode;
  DateTime validationDate;

  Future<void> _validateSMSCode(String code) async {
    try {
      await otpProvider.validateSMS(countryCode, phoneNumber, code, reference);
      if (mounted) {
        setState(() {
          validationDate = otpProvider.validationDate;
        });
      }
      if (validationDate != null) {
        Navigator.of(context).pushReplacementNamed(OTPCompleteProfile.routeName);
        print('validation Date : ${otpProvider.validationDate}');
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      otpProvider = Provider.of<OTPProvider>(context);
      final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      reference = data['reference'];
      phoneNumber = data['phone_number'];
      countryCode = data['country_code'];
      phoneCountryCode = data['phone_country_code'];
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Text(Translations.of(context).get('Check your messages')),
          SizedBox(height: 15),
          Text(Translations.of(context).get('We sent a message to your number')),
          SizedBox(height: 7),
          Text(
            '$phoneCountryCode $phoneNumber',
            style: AppTextStyles.bodyBold,
            textDirection: TextDirection.ltr,
          ),
          Text(Translations.of(context).get('with verification code')),
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 70),
            child: AppPinCodeTextField(
              length: 6,
              onComplete: (pin) {
                _validateSMSCode(pin);
                print(pin);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          SizedBox(height: 20),
          CustomTimer(
            from: Duration(minutes: 3),
            to: Duration(minutes: 0),
            onBuildAction: CustomTimerAction.auto_start,
            onFinish: () {
              //Todo: implement duration end action
            },
            builder: (CustomTimerRemainingTime remaining) {
              return Text(
                "${remaining.minutes}:${remaining.seconds}",
                style: AppTextStyles.h2,
              );
            },
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Translations.of(context).get('Has it not arrived yet?'),
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  //Todo: implement sending code again
                },
                child: Text(
                  Translations.of(context).get('Send again'),
                  style: AppTextStyles.bodySecondaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
