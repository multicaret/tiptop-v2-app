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
import 'package:tiptop_v2/utils/constants.dart';
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
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final GlobalKey<FormState> _phoneNumberFormKey = GlobalKey();
  OTPProvider otpProvider;
  AppProvider appProvider;
  String phoneCountryCode = '';
  String phoneNumber = '';
  String reference;
  String deepLink;
  bool pickedSMSMethod;
  String selectedOTPMethod;

  bool _isLoadingFetchCountriesRequest = false;
  bool _isLoadingInitOTPValidation = false;
  bool _isLoadingCheckOTPValidation = false;
  bool _isInit = true;
  bool isValid;
  bool isNewUser;
  List<Country> countries = [];
  List<Map<String, dynamic>> countriesDropDownItems = [];
  bool resumedFirstTime = true;

  Future<void> _getCountriesFromJsonFile() async {
    setState(() => _isLoadingFetchCountriesRequest = true);
    countries = await getCountriesFromJsonFile();
    phoneCountryCode = countries[0].phoneCode;
    setState(() => _isLoadingFetchCountriesRequest = false);
  }

  Future<void> _initOTPValidation(String method) async {
    setState(() => _isLoadingInitOTPValidation = true);
    await otpProvider.initOTPValidation(method);
    deepLink = otpProvider.deepLink;
    reference = otpProvider.reference;
    setState(() => _isLoadingInitOTPValidation = false);
    if (deepLink != null) {
      launch(deepLink, forceSafariVC: false, forceWebView: false);
    } else {
      print('No deeplink was returned!');
    }
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
    if (state == AppLifecycleState.resumed && resumedFirstTime && pickedSMSMethod != null && !pickedSMSMethod) {
      //To prevent app from running this code everytime the user leaves and returns to the app
      //even if they didn't initiate otp method
      resumedFirstTime = false;
      try {
        setState(() => _isLoadingCheckOTPValidation = true);
        await otpProvider.checkOTPValidation(appProvider, reference);
        isValid = otpProvider.validationStatus;
        isNewUser = otpProvider.isNewUser;
        if (isValid == true) {
          setState(() => _isLoadingCheckOTPValidation = false);
          if (isNewUser) {
            print('New user, navigating to complete profile page');
            Navigator.of(context).pushReplacementNamed(
              OTPCompleteProfile.routeName,
              arguments: {
                'selected_otp_method': selectedOTPMethod,
              },
            );
          } else {
            print('Registered user, navigating to home page');
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(AppWrapper.routeName, (Route<dynamic> route) => false);
          }
        } else {
          setState(() => _isLoadingCheckOTPValidation = false);
          showToast(msg: Translations.of(context).get("OTP Validation Failed"));
          return;
        }
      } catch (error) {
        setState(() => _isLoadingCheckOTPValidation = false);
        showToast(msg: Translations.of(context).get("Validation Failed!"));
        print("@error checkOTPValidation");
        print(error.toString());
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bgColor: AppColors.white,
      hasOverlayLoader: _isLoadingCheckOTPValidation,
      bgImage: "assets/images/page-bg-pattern-white.png",
      bodyPadding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            OTPMethodsButtons(
              initOTPAction: (String method) {
                resumedFirstTime = true;
                selectedOTPMethod = method;
                if (method == 'sms') {
                  setState(() => pickedSMSMethod = true);
                  _getCountriesFromJsonFile();
                } else {
                  setState(() => pickedSMSMethod = false);
                  _initOTPValidation(method);
                }
              },
              isRTL: appProvider.isRTL,
            ),
            if (pickedSMSMethod != null && pickedSMSMethod)
              _isLoadingFetchCountriesRequest
                  ? const AppLoader()
                  : Form(
                      key: _phoneNumberFormKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(Translations.of(context).get("Please Enter Your Phone Number")),
                          const SizedBox(height: 50),
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
                              const SizedBox(width: 15),
                              Expanded(
                                flex: 5,
                                child: AppTextField(
                                  required: true,
                                  textDirection: TextDirection.ltr,
                                  labelText: 'Phone Number',
                                  initialValue: '',
                                  // initialValue: '5070326662',
                                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                  hintText: 'xxx-xxx-xx-xx',
                                  onSaved: (value) {
                                    phoneNumber = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          AppButtons.primary(
                            onPressed: () => _submitPhoneNumberForm(context),
                            child: Text(Translations.of(context).get("Continue")),
                          ),
                        ],
                      ),
                    ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(AppWrapper.routeName, (Route<dynamic> route) => false);
              },
              child: Text(Translations.of(context).get("Continue Without Login")),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitPhoneNumberForm(BuildContext context) async {
    if (!_phoneNumberFormKey.currentState.validate()) {
      showToast(msg: Translations.of(context).get("Invalid Form"));
      return;
    }
    _phoneNumberFormKey.currentState.save();
    try {
      await otpProvider.initSMSOTPAndSendCode(phoneCountryCode, phoneNumber);
      if (otpProvider.reference == null) {
        showToast(msg: Translations.of(context).get("Unable to send SMS code, please try another method!"));
        return;
      }
      Navigator.of(context).pushReplacementNamed(OTPSMSCodePage.routeName, arguments: {
        'reference': otpProvider.reference,
        'phone_country_code': phoneCountryCode,
        'phone_number': phoneNumber,
      });
    } on HttpException catch (error) {
      if (error.errors != null && error.errors.length > 0) {
        appAlert(
          context: context,
          title: Translations.of(context).get("Please make sure the following is corrected"),
          description: error.getErrorsAsString(),
        ).show();
      }
    } catch (e) {
      throw e;
    }
  }
}
