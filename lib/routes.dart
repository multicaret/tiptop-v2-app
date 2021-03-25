import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/about_page.dart';
import 'package:tiptop_v2/UI/pages/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/blog_page.dart';
import 'package:tiptop_v2/UI/pages/cart_page.dart';
import 'package:tiptop_v2/UI/pages/track_order_page.dart';
import 'package:tiptop_v2/UI/pages/checkout_page.dart';
import 'package:tiptop_v2/UI/pages/favorites_page.dart';
import 'package:tiptop_v2/UI/pages/language_select_page.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_complete_profile_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_step_one_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_step_three_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_step_two_page.dart';
import 'package:tiptop_v2/UI/pages/payment_methods_page.dart';
import 'package:tiptop_v2/UI/pages/previous_order_page.dart';
import 'package:tiptop_v2/UI/pages/previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/privacy_page.dart';
import 'package:tiptop_v2/UI/pages/profile_page.dart';
import 'package:tiptop_v2/UI/pages/search_page.dart';
import 'package:tiptop_v2/UI/pages/support_page.dart';
import 'package:tiptop_v2/UI/pages/terms_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';

import 'UI/pages/faq_page.dart';

final routes = <String, WidgetBuilder>{
  AboutPage.routeName: (BuildContext context) => AboutPage(),
  PrivacyPage.routeName: (BuildContext context) => PrivacyPage(),
  TermsPage.routeName: (BuildContext context) => TermsPage(),
  FaqPage.routeName: (BuildContext context) => FaqPage(),
  AddressesPage.routeName: (BuildContext context) => AddressesPage(),
  BlogPage.routeName: (BuildContext context) => BlogPage(),
  FavoritesPage.routeName: (BuildContext context) => FavoritesPage(),
  PaymentMethodsPage.routeName: (BuildContext context) => PaymentMethodsPage(),
  PreviousOrdersPage.routeName: (BuildContext context) => PreviousOrdersPage(),
  SupportPage.routeName: (BuildContext context) => SupportPage(),
  LanguageSelectPage.routeName: (BuildContext context) => LanguageSelectPage(),
  WalkthroughPage.routeName: (BuildContext context) => WalkthroughPage(),
  OTPStepOnePage.routeName: (BuildContext context) => OTPStepOnePage(),
  OTPStepTwoPage.routeName: (BuildContext context) => OTPStepTwoPage(),
  OTPStepThreePage.routeName: (BuildContext context) => OTPStepThreePage(),
  OTPCompleteProfile.routeName: (BuildContext context) => OTPCompleteProfile(),
  LocationPermissionPage.routeName: (BuildContext context) => LocationPermissionPage(),
  AppWrapper.routeName: (BuildContext context) => AppWrapper(),
  SearchPage.routeName: (BuildContext context) => SearchPage(),
  ProfilePage.routeName: (BuildContext context) => ProfilePage(),
  CartPage.routeName: (BuildContext context) => CartPage(),
  CheckoutPage.routeName: (BuildContext context) => CheckoutPage(),
  PreviousOrderPage.routeName: (BuildContext context) => PreviousOrderPage(),
  TrackOrderPage.routeName: (BuildContext context) => TrackOrderPage(),
};
