import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_complete_profile_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_step_one_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/otp_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_wrapper.dart';
import 'otp_step_three_page.dart';

class OTPStepTwoPage extends StatefulWidget {
  static const routeName = '/otp-step-two';

  @override
  _OTPStepTwoPageState createState() => _OTPStepTwoPageState();
}

class _OTPStepTwoPageState extends State<OTPStepTwoPage> with WidgetsBindingObserver {
  AppProvider appProvider;
  OTPProvider otpProvider;
  HomeProvider homeProvider;
  String deepLink;
  String reference;
  String phoneNumber;
  String phoneCountryCode;
  String countryCode = 'TR';
  bool _isLoading = false;
  bool isValid;
  bool isNewUser;
  bool _isInit = true;

  Future<void> _initOTPValidation(String method) async {
    _isLoading = true;
    await otpProvider.initOTPValidation(method);
    setState(() {
      deepLink = otpProvider.deepLink;
      reference = otpProvider.reference;
    });
    launch(deepLink, forceSafariVC: false, forceWebView: false);
  }

  Future<void> _sendOTPSms(String countryCode, String phoneNumber) async {
    try {
      await otpProvider.sendOTPSms(countryCode: countryCode, phoneCountryCode: phoneCountryCode, phoneNumber: phoneNumber);
      setState(() {
        reference = otpProvider.reference;
      });
      Navigator.of(context).pushReplacementNamed(OTPStepThreePage.routeName, arguments: {
        'reference': reference,
        'phone_number': phoneNumber,
        'country_code': countryCode,
        'phone_country_code': phoneCountryCode,
      });
    } catch (e) {
      throw e;
    }
  }

  List<Map<String, dynamic>> getVerificationMethods(BuildContext context) {
    return [
      {
        'name': 'WhatsApp',
        'color': AppColors.whatsApp,
        'icon': FontAwesomeIcons.whatsapp,
        'action': () {
          _initOTPValidation('whatsapp');
        },
      },
      {
        'name': 'Telegram',
        'color': AppColors.telegram,
        'icon': FontAwesomeIcons.telegram,
        'action': () {
          _initOTPValidation('telegram');
        },
      },
      {
        'name': 'SMS',
        'color': AppColors.primary,
        'icon': FontAwesomeIcons.sms,
        'action': () {
          _sendOTPSms(countryCode, phoneNumber);
        },
      },
    ];
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      try {
        await otpProvider.checkOTPValidation(appProvider, reference, phoneCountryCode, phoneNumber);
        isValid = otpProvider.validationStatus;
        _isLoading = false;
        isNewUser = otpProvider.isNewUser;
        if (isValid == true) {
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
      } on HttpException catch (error) {
        appAlert(context: context, title: error.title, description: error.getErrorsAsString()).show();
      } catch (error) {
        print("@error checkOTPValidation");
        print(error.toString());
        // showToast(msg: '${error.message != null ? error.message : 'Unknown error'}');
        // throw error;
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      otpProvider = Provider.of<OTPProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      Map<String, String> data = ModalRoute.of(context).settings.arguments as Map<String, String>;
      phoneNumber = data['phone_number'];
      phoneCountryCode = data['phone_country_code'];

      WidgetsBinding.instance.addObserver(this);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    phoneNumber = data['phone_number'];
    phoneCountryCode = data['phone_country_code'];

    return AppScaffold(
      bodyPadding: EdgeInsets.symmetric(horizontal: 17.0),
      bgImage: 'assets/images/otp-bg-pattern.png',
      hasOverlayLoader: _isLoading,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              Translations.of(context).get('Phone Number Verification'),
              style: AppTextStyles.h2,
            ),
            SizedBox(height: 20),
            Text(
              '$phoneCountryCode $phoneNumber',
              style: AppTextStyles.h1,
              textDirection: TextDirection.ltr,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Translations.of(context).get('Is the number above correct?')),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(OTPStepOnePage.routeName);
                  },
                  child: Text(
                    Translations.of(context).get('No, let me fix it'),
                    style: AppTextStyles.bodySecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 35),
            Text(
              Translations.of(context).get('choose preferred method'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ..._verificationMethodsList(context, appProvider),
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

  List<Widget> _verificationMethodsList(BuildContext context, AppProvider appProvider) {
    List verificationMethods = getVerificationMethods(context);

    return List.generate(verificationMethods.length, (i) {
      return Container(
        padding: EdgeInsets.only(bottom: i == verificationMethods.length - 1 ? 0 : 20),
        child: AppButtons.dynamic(
            onPressed: verificationMethods[i]['action'],
            bgColor: verificationMethods[i]['color'],
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: appProvider.dir == 'ltr' ? Alignment.centerRight : Alignment.centerLeft,
                    child: Icon(verificationMethods[i]['icon']),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  flex: 3,
                  child: Text(
                    "${Translations.of(context).get('Continue Via')} ${verificationMethods[i]['name']}",
                  ),
                )
              ],
            )),
      );
    });
  }
}
