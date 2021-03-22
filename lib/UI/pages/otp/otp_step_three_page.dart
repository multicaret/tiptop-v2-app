import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_complete_profile_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_pin_code_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/otp_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class OTPStepThreePage extends StatefulWidget {
  static const routeName = '/otp-step-three';

  @override
  _OTPStepThreePageState createState() => _OTPStepThreePageState();
}

class _OTPStepThreePageState extends State<OTPStepThreePage> {
  OTPProvider otpProvider;
  AppProvider appProvider;
  HomeProvider homeProvider;
  bool _isInit = true;
  String reference;
  String phoneCountryCode;
  String phoneNumber;
  String countryCode;
  DateTime validationDate;

  bool isValid;
  bool isNewUser;

  Future<void> _validateSMSCode(String code) async {
    try {
      await otpProvider.validateSMS(appProvider, countryCode, phoneCountryCode, phoneNumber, code, reference);
      isValid = otpProvider.validationStatus;
      isNewUser = otpProvider.isNewUser;
      if (isValid == true) {
        homeProvider.selectCategory(null);
        if (isNewUser) {
          print('New user, navigating to complete profile page');
          Navigator.of(context).pushReplacementNamed(OTPCompleteProfile.routeName);
        } else {
          print('Registered user, navigating to home page');
          Navigator.of(context).pushReplacementNamed(AppWrapper.routeName);
        }
      } else {
        showToast(msg: 'OTP Validation Failed');
      }
    } catch (error) {
      showToast(msg: '${error.message != null ? error.message : 'Unknown error'}');
      throw error;
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      otpProvider = Provider.of<OTPProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
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
