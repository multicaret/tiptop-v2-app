import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/faq_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/privacy_page.dart';
import 'package:tiptop_v2/UI/pages/profile/about_page.dart';
import 'package:tiptop_v2/UI/pages/profile/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/profile/blog_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_products_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_restaurants_page.dart';
import 'package:tiptop_v2/UI/pages/market/order/market_previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/support_page.dart';
import 'package:tiptop_v2/UI/pages/terms_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_select_items.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/profile_auth_header.dart';
import 'package:tiptop_v2/UI/widgets/profile_setting_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';

  List<Map<String, dynamic>> getAuthProfileItems(bool _channelIsMarket) {
    return [
      {
        'title': "My Addresses",
        'icon': FontAwesomeIcons.mapMarked,
        'route': AddressesPage.routeName,
      },
      {
        'title': _channelIsMarket ? "Favorite Products" : "Favorite Restaurants",
        'icon': FontAwesomeIcons.solidHeart,
        'route': _channelIsMarket ? FavoriteMarketProductsPage.routeName : FavoriteRestaurantsPage.routeName,
      },
      {
        'title': "Previous Orders",
        'icon': _channelIsMarket ? FontAwesomeIcons.shoppingBag : FontAwesomeIcons.utensils,
        'route': _channelIsMarket ? MarketPreviousOrdersPage.routeName : FoodPreviousOrdersPage.routeName,
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
    return Consumer2<AppProvider, HomeProvider>(
      builder: (c, appProvider, homeProvider, _) {
        Language selectedLanguage =
            appProvider.appLanguages.firstWhere((language) => language.locale == appProvider.appLocale.languageCode, orElse: () => null);
        int selectedLanguageId = selectedLanguage.id;

        return AppScaffold(
          hasCurve: false,
          appBar: AppBar(
            title: Text(Translations.of(context).get('Profile')),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ProfileAuthHeader(),
                const SizedBox(height: 30),
                ProfileSettingItem(
                  title: 'Support',
                  icon: FontAwesomeIcons.headphones,
                  route: SupportPage.routeName,
                ),
                if (appProvider.isAuth) ..._getProfileSettingItems(context, getAuthProfileItems(homeProvider.channelIsMarket)),
                SectionTitle('Languages'),
                RadioSelectItems(
                  items: appProvider.appLanguages.map((language) => {'id': language.id, 'title': language.title, 'logo': language.logo}).toList(),
                  selectedId: selectedLanguageId,
                  action: (languageId) {
                    Language selectedLanguage = appProvider.appLanguages.firstWhere((language) => language.id == languageId);
                    appProvider.changeLanguage(selectedLanguage.locale);
                  },
                  isAssetLogo: true,
                ),
                const SizedBox(height: 30),
                ..._getProfileSettingItems(context, profileItems),
                const SizedBox(height: 30),
                if (appProvider.isAuth)
                  ProfileSettingItem(
                    title: 'Logout',
                    icon: FontAwesomeIcons.doorOpen,
                    action: appProvider.logout,
                    hasTrailing: false,
                  ),
                const SizedBox(height: 50),
                ProfileSettingItem(
                  title: 'Version',
                  icon: FontAwesomeIcons.mobileAlt,
                  trailing: Text(
                    '1.0.0',
                    style: AppTextStyles.body50,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _getProfileSettingItems(BuildContext context, List<Map<String, dynamic>> _items) {
    return List.generate(
      _items.length,
      (i) => ProfileSettingItem(
        icon: _items[i]['icon'],
        title: _items[i]['title'],
        route: _items[i]['route'],
      ),
    );
  }
}
