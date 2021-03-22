import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_complete_profile_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class LoginHeaderContainer extends StatelessWidget {
  final AppProvider appProvider;

  LoginHeaderContainer({this.appProvider});

  BoxShadow containerShadow() {
    return BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [containerShadow()],
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
          appProvider.isAuth
              ? UserInfo(
                  appProvider: appProvider,
                  name: appProvider.authUser.name,
                  phoneNumber: '${appProvider.authUser.phoneCode} ${appProvider.authUser.phone}',
                )
              : SignUpContainer(appProvider: appProvider),
        ],
      ),
    );
  }
}

class SignUpContainer extends StatelessWidget {
  final AppProvider appProvider;

  SignUpContainer({this.appProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      child: Row(
        children: [
          Text(Translations.of(context).get("Sign Up"), style: AppTextStyles.bodyBold),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pushNamed(WalkthroughPage.routeName),
            icon: appProvider.dir == 'ltr' ? Icon(FontAwesomeIcons.angleRight) : FontAwesomeIcons.angleLeft,
          ),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final AppProvider appProvider;
  final String name;
  final String phoneNumber;

  UserInfo({this.appProvider, this.name, this.phoneNumber});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(name, style: AppTextStyles.bodyBoldSecondaryDark),
              Text(phoneNumber, style: AppTextStyles.subtitle),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pushNamed(OTPCompleteProfile.routeName),
            icon: Icon(FontAwesomeIcons.pen, color: AppColors.secondaryDark, size: 20),
          ),
        ],
      ),
    );
  }
}
