import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/profile_setting_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

class LanguagesContainer extends StatelessWidget {
  final AppProvider appProvider;

  LanguagesContainer({this.appProvider});

  @override
  Widget build(BuildContext context) {
    return ProfileSettingItem(
      appProvider: appProvider,
      hasChildren: true,
      title: Translations.of(context).get("Languages"),
      icon: FontAwesomeIcons.language,
      children: Row(
        children: List.generate(
          appProvider.appLanguages.length,
          (i) => Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: () {
                appProvider.changeLanguage(
                  appProvider.appLanguages[i]['locale'],
                );
              },
              child: Image.asset(
                appProvider.appLanguages[i]['flag'],
                height: 35.0,
                width: 35.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
