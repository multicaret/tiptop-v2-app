import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class LoginHeaderContainer extends StatelessWidget {
  final AppProvider appProvider;
  final Function onTap;

  LoginHeaderContainer({this.appProvider, this.onTap});

  BoxShadow containerShadow() {
    return BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        height: 80.0,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Row(
              children: [
                Container(
                  child: Icon(Icons.person_rounded),
                  height: 55.0,
                  width: 55.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [containerShadow()],
                  ),
                ),
                SizedBox(width: 10.0),
                //Text(appProvider.isAuth ? 'Logout' : 'Login'),
                Text(Translations.of(context).get("Login"), style: AppTextStyles.h2),
              ],
            ),
            Spacer(),
            Icon(appProvider.dir == 'ltr' ? FontAwesomeIcons.angleRight : FontAwesomeIcons.angleLeft),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [containerShadow()],
        ),
      ),
    );
  }
}
