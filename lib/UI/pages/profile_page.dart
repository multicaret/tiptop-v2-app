import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/general_items.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/languages_container.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/profile_setting_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'otp/otp_complete_profile_page.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get('Profile')),
      ),
      body: Container(
        color: AppColors.bg,
        child: SingleChildScrollView(
          child: Column(
            children: [
              LoginHeaderContainer(appProvider: appProvider),
              SizedBox(height: 30.0),
              GeneralItems(appProvider: appProvider),
              SizedBox(height: 30.0),
              ProfileSettingItem(
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
                  }),
              SizedBox(height: 30.0),
              LanguagesContainer(appProvider: appProvider),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginHeaderContainer extends StatelessWidget {
  final AppProvider appProvider;

  LoginHeaderContainer({this.appProvider});

  BoxShadow containerShadow() {
    return BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(appProvider.isAuth ? OTPCompleteProfile.routeName : WalkthroughPage.routeName);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          height: 80.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              Container(
                child: Icon(Icons.person_rounded),
                height: 55.0,
                width: 55.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [containerShadow()],
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appProvider.isAuth
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                appProvider.authUser.name,
                                style: AppTextStyles.bodyBoldSecondaryDark,
                              ),
                              Text(
                                '${appProvider.authUser.phoneCode} ${appProvider.authUser.phone}',
                                style: AppTextStyles.subtitle,
                              ),
                            ],
                          )
                        : Text(Translations.of(context).get("Sign Up"), style: AppTextStyles.bodyBold),
                    appProvider.isAuth
                        ? AppIcon.iconSecondary(FontAwesomeIcons.pen)
                        : AppIcon.iconSecondary(appProvider.isRTL ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
