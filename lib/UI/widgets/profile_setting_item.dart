import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';

class ProfileSettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final Function action;
  final Widget trailing;
  final bool hasTrailing;

  ProfileSettingItem({
    @required this.icon,
    @required this.title,
    this.route,
    this.action,
    this.trailing,
    this.hasTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (c, appProvider, _) => Material(
        color: AppColors.white,
        child: InkWell(
          onTap: _determineTapMethod(context: context, action: action, route: route),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
            height: 70,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: AppColors.secondaryDark,
                    ),
                    SizedBox(width: 20.0),
                    Text(Translations.of(context).get(title)),
                  ],
                ),
                if (hasTrailing) trailing ?? AppIcon.iconPrimary(appProvider.isRTL ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _determineTapMethod({BuildContext context, Function action, String route}) {
    if (action != null) {
      return action;
    }
    if (route != null) {
      return () {
        Navigator.of(context, rootNavigator: true).pushNamed(route);
      };
    }
    return null;
  }
}
