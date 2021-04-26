import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/market/order/market_checkout_page.dart';
import 'package:tiptop_v2/UI/pages/faq_page.dart';
import 'package:tiptop_v2/UI/pages/food/food_cart_page.dart';
import 'package:tiptop_v2/UI/pages/food/food_product_page.dart';
import 'package:tiptop_v2/UI/pages/food/food_search_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_order_rating_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_previous_order_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurant_page.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurants_page.dart';
import 'package:tiptop_v2/UI/pages/language_select_page.dart';
import 'package:tiptop_v2/UI/pages/live_chat_page.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/pages/market/market_cart_page.dart';
import 'package:tiptop_v2/UI/pages/market/order/market_order_rating_page.dart';
import 'package:tiptop_v2/UI/pages/market/market_product_page.dart';
import 'package:tiptop_v2/UI/pages/market/market_search_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_choose_method_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_complete_profile_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_sms_code_page.dart';
import 'package:tiptop_v2/UI/pages/privacy_page.dart';
import 'package:tiptop_v2/UI/pages/profile/about_page.dart';
import 'package:tiptop_v2/UI/pages/profile/add_address_page.dart';
import 'package:tiptop_v2/UI/pages/profile/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/profile/article_page.dart';
import 'package:tiptop_v2/UI/pages/profile/blog_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_products_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_restaurants_page.dart';
import 'package:tiptop_v2/UI/pages/market/order/market_previous_order_page.dart';
import 'package:tiptop_v2/UI/pages/market/order/market_previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/profile/payment_methods_page.dart';
import 'package:tiptop_v2/UI/pages/profile/profile_page.dart';
import 'package:tiptop_v2/UI/pages/support_page.dart';
import 'package:tiptop_v2/UI/pages/terms_page.dart';
import 'package:tiptop_v2/UI/pages/track_order_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';

import 'UI/pages/food/order/food_checkout_page.dart';

final routes = <String, WidgetBuilder>{
  AboutPage.routeName: (BuildContext context) => AboutPage(),
  PrivacyPage.routeName: (BuildContext context) => PrivacyPage(),
  TermsPage.routeName: (BuildContext context) => TermsPage(),
  FaqPage.routeName: (BuildContext context) => FaqPage(),
  AddressesPage.routeName: (BuildContext context) => AddressesPage(),
  BlogPage.routeName: (BuildContext context) => BlogPage(),
  FavoriteMarketProductsPage.routeName: (BuildContext context) => FavoriteMarketProductsPage(),
  PaymentMethodsPage.routeName: (BuildContext context) => PaymentMethodsPage(),
  LiveChatPage.routeName: (BuildContext context) => LiveChatPage(),
  LanguageSelectPage.routeName: (BuildContext context) => LanguageSelectPage(),
  WalkthroughPage.routeName: (BuildContext context) => WalkthroughPage(),
  OTPChooseMethodPage.routeName: (BuildContext context) => OTPChooseMethodPage(),
  OTPSMSCodePage.routeName: (BuildContext context) => OTPSMSCodePage(),
  OTPCompleteProfile.routeName: (BuildContext context) => OTPCompleteProfile(),
  LocationPermissionPage.routeName: (BuildContext context) => LocationPermissionPage(),
  AppWrapper.routeName: (BuildContext context) => AppWrapper(),
  MarketSearchPage.routeName: (BuildContext context) => MarketSearchPage(),
  FoodSearchPage.routeName: (BuildContext context) => FoodSearchPage(),
  ProfilePage.routeName: (BuildContext context) => ProfilePage(),
  MarketCartPage.routeName: (BuildContext context) => MarketCartPage(),
  MarketCheckoutPage.routeName: (BuildContext context) => MarketCheckoutPage(),
  MarketPreviousOrderPage.routeName: (BuildContext context) => MarketPreviousOrderPage(),
  MarketPreviousOrdersPage.routeName: (BuildContext context) => MarketPreviousOrdersPage(),
  MarketOrderRatingPage.routeName: (BuildContext context) => MarketOrderRatingPage(),
  FoodPreviousOrderPage.routeName: (BuildContext context) => FoodPreviousOrderPage(),
  FoodPreviousOrdersPage.routeName: (BuildContext context) => FoodPreviousOrdersPage(),
  FoodOrderRatingPage.routeName: (BuildContext context) => FoodOrderRatingPage(),
  AddAddressPage.routeName: (BuildContext context) => AddAddressPage(),
  TrackOrderPage.routeName: (BuildContext context) => TrackOrderPage(),
  MarketProductPage.routeName: (BuildContext context) => MarketProductPage(),
  SupportPage.routeName: (BuildContext context) => SupportPage(),
  ArticlePage.routeName: (BuildContext context) => ArticlePage(),
  RestaurantPage.routeName: (BuildContext context) => RestaurantPage(),
  FoodProductPage.routeName: (BuildContext context) => FoodProductPage(),
  FoodCartPage.routeName: (BuildContext context) => FoodCartPage(),
  RestaurantsPage.routeName: (BuildContext context) => RestaurantsPage(),
  FavoriteRestaurantsPage.routeName: (BuildContext context) => FavoriteRestaurantsPage(),
  FoodCheckoutPage.routeName: (BuildContext context) => FoodCheckoutPage(),
};
