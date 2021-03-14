import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/main_page.dart';
import 'package:tiptop_v2/UI/pages/language_select_page.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_complete_profile_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_step_one_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_step_three_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';

import 'UI/pages/otp/otp_step_two_page.dart';

final routes = <String, WidgetBuilder>{
  LanguageSelectPage.routeName: (BuildContext context) => LanguageSelectPage(),
  WalkthroughPage.routeName: (BuildContext context) => WalkthroughPage(),
  OTPStepOnePage.routeName: (BuildContext context) => OTPStepOnePage(),
  OTPStepTwoPage.routeName: (BuildContext context) => OTPStepTwoPage(),
  OTPStepThreePage.routeName: (BuildContext context) => OTPStepThreePage(),
  OTPCompleteProfile.routeName: (BuildContext context) => OTPCompleteProfile(),
  LocationPermissionPage.routeName: (BuildContext context) => LocationPermissionPage(),
  MainPage.routeName: (BuildContext context) => MainPage(),
};
