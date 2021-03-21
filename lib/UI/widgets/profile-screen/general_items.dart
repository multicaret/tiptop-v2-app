import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/pages/about_page.dart';
import 'package:tiptop_v2/UI/pages/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/blog_page.dart';
import 'package:tiptop_v2/UI/pages/favorites_page.dart';
import 'package:tiptop_v2/UI/pages/payment_methods_page.dart';
import 'package:tiptop_v2/UI/pages/previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/privacy_page.dart';
import 'package:tiptop_v2/UI/pages/support_page.dart';
import 'package:tiptop_v2/UI/pages/terms_page.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/profile_setting_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

class GeneralItems extends StatelessWidget {
  final AppProvider appProvider;

  GeneralItems({this.appProvider});

  final List<Map<String, dynamic>> profileItems = [
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
    {
      'title': "Payment Methods",
      'icon': FontAwesomeIcons.ccMastercard,
      'route': PaymentMethodsPage.routeName,
    },
    {
      'title': "Support",
      'icon': FontAwesomeIcons.headphones,
      'route': SupportPage.routeName,
    },
    {
      'title': "Blog",
      'icon': FontAwesomeIcons.newspaper,
      'route': BlogPage.routeName,
    },
    {
      'title': "FAQ",
      'icon': FontAwesomeIcons.solidQuestionCircle,
      'route': AboutPage.routeName,
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

  BoxShadow containerShadow() {
    return BoxShadow(
      color: Colors.grey.withOpacity(0.3),
      spreadRadius: 1,
      blurRadius: 3,
      offset: Offset(0, 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [containerShadow()],
        color: Colors.white,
      ),
      child: Column(
        children: List.generate(
          profileItems.length,
          (i) => ProfileSettingItem(
            appProvider: appProvider,
            hasChildren: false,
            icon: profileItems[i]['icon'],
            title: Translations.of(context).get(profileItems[i]['title']),
            onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(profileItems[i]['route']),
          ),
        ),
      ),
    );
  }
}
