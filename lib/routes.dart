import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_step_one_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';

final routes = <String, WidgetBuilder>{
  WalkthroughPage.routeName: (BuildContext context) => WalkthroughPage(),
  OTPStepOnePage.routeName: (BuildContext context) => OTPStepOnePage(),
};
