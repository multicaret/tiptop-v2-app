import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/privacy_page.dart';
import 'package:tiptop_v2/UI/pages/profile/previous_orders_page.dart';
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
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../faq_page.dart';
import 'about_page.dart';
import 'addresses_page.dart';
import 'blog_page.dart';
import 'favorites_page.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';

  final List<Map<String, dynamic>> authProfileItems = [
    {
      'title': "My Addresses",
      'icon': FontAwesomeIcons.mapMarked,
      'route': AddressesPage.routeName,
    },
    {
      'title': "My Favorites",
      'icon': FontAwesomeIcons.solidHeart,
      'route': FavoritesPage.routeName,
    },
    {
      'title': "Previous Orders",
      'icon': FontAwesomeIcons.shoppingBag,
      'route': PreviousOrdersPage.routeName,
    },
  ];

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
    return Consumer<AppProvider>(
      builder: (c, appProvider, _) {
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
                SizedBox(height: 30),
                ProfileSettingItem(
                  title: 'Support',
                  icon: FontAwesomeIcons.headphones,
                  route: SupportPage.routeName,
                ),
                if (appProvider.isAuth) ..._getProfileSettingItems(context, authProfileItems),
                SectionTitle('Languages'),
                RadioSelectItems(
                  items: appProvider.appLanguages.map((language) => {'id': language.id, 'title': language.title, 'logo': language.logo}).toList(),
                  selectedId: selectedLanguageId,
                  action: (languageId) {
                    Language selectedLanguage = appProvider.appLanguages.firstWhere((language) => language.id == languageId);
                    appProvider.changeLanguage(selectedLanguage.locale);
                  },
                  isRTL: appProvider.isRTL,
                  isAssetLogo: true,
                ),
                SizedBox(height: 30),
                ..._getProfileSettingItems(context, profileItems),
                SizedBox(height: 30),
                if (appProvider.isAuth)
                  ProfileSettingItem(
                    title: 'Logout',
                    icon: FontAwesomeIcons.doorOpen,
                    action: appProvider.logout,
                    hasTrailing: false,
                  ),
                SizedBox(height: 50),
                ProfileSettingItem(
                  title: 'Version',
                  icon: FontAwesomeIcons.mobileAlt,
                  trailing: Text(
                    '1.0.0',
                    style: AppTextStyles.body50,
                  ),
                ),
                SizedBox(height: 30),
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
