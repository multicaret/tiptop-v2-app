import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_complete_profile_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ProfileAuthHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (c, appProvider, _) => Material(
        color: AppColors.white,
        child: InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(
              appProvider.isAuth ? OTPCompleteProfile.routeName : WalkthroughPage.routeName,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10),
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
                  child: AppIcons.iconMdPrimary(FontAwesomeIcons.solidUser),
                  height: 55.0,
                  width: 55.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      const BoxShadow(color: AppColors.shadow, blurRadius: 6),
                    ],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(width: 10.0),
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
                                  '+${appProvider.authUser.phoneCode} ${appProvider.authUser.phone}',
                                  style: AppTextStyles.subtitle,
                                  textDirection: TextDirection.ltr,
                                ),
                              ],
                            )
                          : Text('${Translations.of(context).get("Register")} / ${Translations.of(context).get("Log In")}',
                              style: AppTextStyles.bodyBold),
                      appProvider.isAuth
                          ? AppIcons.iconSecondary(FontAwesomeIcons.pen)
                          : AppIcons.iconSecondary(appProvider.isRTL ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
