import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/country_code_dropdown.dart';
import 'package:tiptop_v2/UI/widgets/otp_methods_buttons.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/otp_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'otp_complete_profile_page.dart';
import 'otp_sms_code_page.dart';

class OTPChooseMethodPage extends StatefulWidget {
  static const routeName = '/otp-step-one';

  @override
  _OTPChooseMethodPageState createState() => _OTPChooseMethodPageState();
}

class _OTPChooseMethodPageState extends State<OTPChooseMethodPage> with WidgetsBindingObserver {
  final GlobalKey<FormState> _phoneNumberFormKey = GlobalKey();
  OTPProvider otpProvider;
  AppProvider appProvider;
  String phoneCountryCode = '';
  String phoneNumber = '';
  String reference;
  String deepLink;
  bool pickedSMSMethod;

  bool _isLoadingFetchCountriesRequest = false;
  bool _isLoadingInitOTPValidation = false;
  bool _isLoadingCheckOTPValidation = false;
  bool _isInit = true;
  bool isValid;
  bool isNewUser;
  List<Country> countries = [];
  List<Map<String, dynamic>> countriesDropDownItems = [];

  Future<void> _fetchAndSetCountries() async {
    setState(() => _isLoadingFetchCountriesRequest = true);
    await otpProvider.fetchAndSetCountries();
    countries = otpProvider.countries;
    phoneCountryCode = countries[0].phoneCode;
    setState(() => _isLoadingFetchCountriesRequest = false);
  }

  Future<void> _initOTPValidation(String method) async {
    setState(() => _isLoadingInitOTPValidation = true);
    await otpProvider.initOTPValidation(method);
    setState(() {
      deepLink = otpProvider.deepLink;
      reference = otpProvider.reference;
      _isLoadingInitOTPValidation = false;
    });
    launch(deepLink, forceSafariVC: false, forceWebView: false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      otpProvider = Provider.of<OTPProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      WidgetsBinding.instance.addObserver(this);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && pickedSMSMethod != null && !pickedSMSMethod) {
      try {
        setState(() => _isLoadingCheckOTPValidation = true);
        await otpProvider.checkOTPValidation(appProvider, reference);
        isValid = otpProvider.validationStatus;
        isNewUser = otpProvider.isNewUser;
        if (isValid == true) {
          setState(() => _isLoadingCheckOTPValidation = false);
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
        setState(() => _isLoadingCheckOTPValidation = false);
      } catch (error) {
        print("@error checkOTPValidation");
        print(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bgColor: AppColors.white,
      hasOverlayLoader: _isLoadingCheckOTPValidation,
      bgImage: "assets/images/page-bg-pattern-white.png",
      bodyPadding: EdgeInsets.symmetric(horizontal: 17.0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            OTPMethodsButtons(
              initOTPAction: (String method) {
                if (method == 'sms') {
                  setState(() => pickedSMSMethod = true);
                  _fetchAndSetCountries();
                } else {
                  setState(() => pickedSMSMethod = false);
                  _initOTPValidation(method);
                }
              },
              isRTL: appProvider.isRTL,
            ),
            if (pickedSMSMethod != null && pickedSMSMethod)
              _isLoadingFetchCountriesRequest
                  ? AppLoader()
                  : Form(
                      key: _phoneNumberFormKey,
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
                                child: CountryCodeDropDown(
                                  countries: countries,
                                  currentCountryPhoneCode: phoneCountryCode,
                                  onChange: (selectedPhoneCode) => setState(() => phoneCountryCode = selectedPhoneCode),
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
                                  keyboardType: TextInputType.numberWithOptions(signed: true),
                                  hintText: '5xx-xxx-xx-xx',
                                  onSaved: (value) {
                                    phoneNumber = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          AppButtons.primary(
                            onPressed: () => _submitPhoneNumberForm(context),
                            child: Text(Translations.of(context).get('Continue')),
                          ),
                        ],
                      ),
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

  Future<void> _submitPhoneNumberForm(BuildContext context) async {
    if (!_phoneNumberFormKey.currentState.validate()) {
      showToast(msg: Translations.of(context).get('Invalid Form'));
      return;
    }
    _phoneNumberFormKey.currentState.save();
    await otpProvider.initSMSOTPAndSendCode(phoneCountryCode, phoneNumber);
    if (otpProvider.reference == null) {
      showToast(msg: 'Unable to send SMS code, please try another method!');
      return;
    }
    Navigator.of(context).pushReplacementNamed(OTPSMSCodePage.routeName, arguments: {
      'reference': otpProvider.reference,
      'phone_country_code': phoneCountryCode,
      'phone_number': phoneNumber,
    });
  }
}
