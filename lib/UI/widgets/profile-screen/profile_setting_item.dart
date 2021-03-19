import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class ProfileSettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool hasChildren;
  final Widget children;
  final Function onTap;
  final AppProvider appProvider;

  ProfileSettingItem({
    this.icon,
    this.title,
    this.hasChildren,
    this.children,
    this.onTap,
    this.appProvider,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
            height: 70,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.secondaryDark,
                ),
                SizedBox(width: 20.0),
                Text(title),
                Spacer(),
                !hasChildren ? Icon(appProvider.dir == 'ltr' ? FontAwesomeIcons.angleRight : FontAwesomeIcons.angleLeft) : children,
              ],
            ),
          ),
        ),
        Divider(thickness: 0.5, color: Colors.grey, height: 1),
      ],
    );
  }
}
