import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/profile_setting_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

class LogoutContainer extends StatelessWidget {
  final AppProvider appProvider;

  LogoutContainer({this.appProvider});

  @override
  Widget build(BuildContext context) {
    return ProfileSettingItem(
        appProvider: appProvider,
        hasChildren: false,
        title: Translations.of(context).get("Logout"),
        icon: FontAwesomeIcons.doorOpen,
        onTap: () {
          if (appProvider.isAuth) {
            appProvider.logout();
          } else {
            Navigator.of(context, rootNavigator: true).pushNamed(WalkthroughPage.routeName);
          }
        });
  }
}
