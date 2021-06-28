import 'dart:io';

import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ForceUpdatePage extends StatelessWidget {
  final AppProvider appProvider;
  final bool isSoftUpdateEnabled;

  const ForceUpdatePage({Key key, this.appProvider, this.isSoftUpdateEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool hasStoreLink = Platform.isAndroid
        ? appProvider.remoteConfigs.data['android_store_link_package'] != null
        : appProvider.remoteConfigs.data['apple_store_link_app_id'] != null;

    return AppScaffold(
      hasCurve: true,
      bgColor: AppColors.white,
      bgImage: "assets/images/page-bg-pattern-white.png",
      bodyPadding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
      body: Column(
        children: [
          SizedBox(height: screenSize.height * 0.2),
          getUpperImage(screenSize),
          const SizedBox(height: 50),
          getDialogTitle(),
          const SizedBox(height: 10),
          getDialogContent(),
          const SizedBox(height: 30),
          if (hasStoreLink)
            AppButtons.primary(
              onPressed: () {
                String appPackageName;
                var androidStoreLinkPackage = appProvider.remoteConfigs.data['android_store_link_package'];
                if (androidStoreLinkPackage != null) {
                  print("appProvider.remoteConfigs.data['android_store_link_package']");
                  appPackageName = androidStoreLinkPackage;
                  // print(appPackageName);
                }

                String iosAppId;
                String appleStoreLinkAppId = appProvider.remoteConfigs.data['apple_store_link_app_id'];
                if (appleStoreLinkAppId != null && appleStoreLinkAppId.isNotEmpty) {
                  print("appProvider.remoteConfigs.data['apple_store_link_app_id']");
                  iosAppId = appleStoreLinkAppId;
                  print(iosAppId);
                }
                LaunchReview.launch(androidAppId: appPackageName, iOSAppId: iosAppId);
              },
              child: Text("Open Store"),
            ),
          const SizedBox(height: 20),
          if (isSoftUpdateEnabled)
            AppButtons.secondary(
              child: Text(Translations.of(context).get("Continue")),
              onPressed: () => pushAndRemoveUntilCupertinoPage(
                context,
                AppWrapper(targetAppChannel: appProvider.appDefaultChannel),
              ),
            ),
        ],
      ),
    );
  }

  Text getDialogTitle() {
    String text = "Update Required";
    if (appProvider.remoteConfigs.dataTranslated?.dialog != null) text = appProvider.remoteConfigs.dataTranslated.dialog.title;
    return Text(text, style: AppTextStyles.h1);
  }

  Text getDialogContent() {
    String text = "Please update the application from the store";
    if (appProvider.remoteConfigs.dataTranslated?.dialog != null) text = appProvider.remoteConfigs.dataTranslated.dialog.content;
    return Text(
      text,
      style: AppTextStyles.body,
      textAlign: TextAlign.center,
    );
  }

  Image getUpperImage(Size screenSize) {
    return appProvider.remoteConfigs.data['image'] != null
        ? Image.network(
            appProvider.remoteConfigs.data['image'],
            width: screenSize.width / 2.5,
          )
        : Image.asset(
            'assets/images/tiptop-logo.png',
            width: screenSize.width / 2.5,
          );
  }
}
