import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/faq_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/market/order/market_previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/privacy_page.dart';
import 'package:tiptop_v2/UI/pages/profile/about_page.dart';
import 'package:tiptop_v2/UI/pages/profile/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/profile/blog_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_products_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_restaurants_page.dart';
import 'package:tiptop_v2/UI/pages/support_page.dart';
import 'package:tiptop_v2/UI/pages/terms_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_list_items.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/profile_auth_header.dart';
import 'package:tiptop_v2/UI/widgets/profile_setting_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/one_signal_notifications_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../../app_wrapper.dart';

class ProfilePage extends StatelessWidget {
  final AppChannel currentChannel;

  ProfilePage({this.currentChannel});

  List<Map<String, dynamic>> getAuthProfileItems() {
    return [
      {
        'title': "My Addresses",
        'icon': FontAwesomeIcons.mapMarked,
        'route': AddressesPage.routeName,
        'route_arguments': {'current_channel': currentChannel},
      },
      {
        'title': currentChannel == AppChannel.MARKET ? "Favorite Products" : "Favorite Restaurants",
        'icon': FontAwesomeIcons.solidHeart,
        'route': currentChannel == AppChannel.MARKET ? FavoriteMarketProductsPage.routeName : FavoriteRestaurantsPage.routeName,
      },
      {
        'title': "Previous Orders",
        'icon': currentChannel == AppChannel.MARKET ? FontAwesomeIcons.shoppingBag : FontAwesomeIcons.utensils,
        'route': currentChannel == AppChannel.MARKET ? MarketPreviousOrdersPage.routeName : FoodPreviousOrdersPage.routeName,
      },
    ];
  }

  final List<Map<String, dynamic>> profileItems = [
    {
      'title': "Blog",
      'icon': FontAwesomeIcons.newspaper,
      'route': BlogPage.routeName,
    },
    {
      'title': "FAQ",
      'icon': FontAwesomeIcons.solidQuestionCircle,
      'route': FaqPage.routeName,
    },
    {
      'title': "About TipTop",
      'icon': FontAwesomeIcons.infoCircle,
      'route': AboutPage.routeName,
    },
    {
      'title': "Privacy Policy",
      'icon': FontAwesomeIcons.userLock,
      'route': PrivacyPage.routeName,
    },
    {
      'title': "Terms and Conditions",
      'icon': FontAwesomeIcons.solidFileAlt,
      'route': TermsPage.routeName,
    },
  ];

  @override
  Widget build(BuildContext context) {
    OneSignalNotificationsProvider _oneSignalNotificationsProvider = Provider.of<OneSignalNotificationsProvider>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: AppScaffold(
        hasCurve: false,
        appBar: AppBar(
          title: Text(Translations.of(context).get("Profile")),
        ),
        body: Consumer<AppProvider>(
          builder: (c, appProvider, _) {
            Language selectedLanguage =
                appProvider.appLanguages.firstWhere((language) => language.locale == appProvider.appLocale.languageCode, orElse: () => null);
            int selectedLanguageId = selectedLanguage.id;

            return SingleChildScrollView(
              child: Column(
                children: [
                  ProfileAuthHeader(),
                  const SizedBox(height: 30),
                  ProfileSettingItem(
                    title: 'Support',
                    icon: FontAwesomeIcons.headphones,
                    route: SupportPage.routeName,
                  ),
                  if (appProvider.isAuth) ..._getProfileSettingItems(context, getAuthProfileItems()),
                  SectionTitle('Languages'),
                  Consumer<ProductsProvider>(
                    builder: (c, productsProvider, _) => RadioListItems(
                      items: appProvider.appLanguages.map((language) => {'id': language.id, 'title': language.title, 'logo': language.logo}).toList(),
                      selectedId: selectedLanguageId,
                      action: (languageId) async {
                        Language selectedLanguage = appProvider.appLanguages.firstWhere((language) => language.id == languageId);
                        appProvider.changeLanguage(selectedLanguage.locale);
                        pushAndRemoveUntilCupertinoPage(
                          context,
                          AppWrapper(
                            targetAppChannel: currentChannel,
                            forceMarketHomeDataRefresh: true,
                            forceFoodHomeDataRefresh: true,
                          ),
                        );
                      },
                      isAssetLogo: true,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ..._getProfileSettingItems(context, profileItems),
                  const SizedBox(height: 30),
                  if (appProvider.isAuth)
                    ProfileSettingItem(
                      title: 'Logout',
                      icon: FontAwesomeIcons.doorOpen,
                      action: () {
                        //Remove OneSignal external user id to disable notifications then logout
                        _oneSignalNotificationsProvider.handleRemoveExternalUserId().then((_) {
                          print('removed user external user Id from OneSignal');
                          appProvider.logout();
                        }).catchError((e) {
                          print('Error occurred while trying to remove user external user Id from OneSignal');
                          print(e);
                          appProvider.logout();
                        });
                      },
                      hasTrailing: false,
                    ),
                  const SizedBox(height: 50),
                  ProfileSettingItem(
                    title: 'Version',
                    icon: FontAwesomeIcons.mobileAlt,
                    trailing: Text(
                      '${AppProvider.mobileAppDetails['version']}.${AppProvider.mobileAppDetails['buildNumber']}',
                      style: AppTextStyles.body50,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _getProfileSettingItems(BuildContext context, List<Map<String, dynamic>> _items) {
    return List.generate(
      _items.length,
      (i) => ProfileSettingItem(
        icon: _items[i]['icon'],
        title: _items[i]['title'],
        route: _items[i]['route'],
        routeArguments: _items[i]['route_arguments'],
      ),
    );
  }
}
