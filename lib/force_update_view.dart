import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/local_storage.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

import 'UI/widgets/UI/app_scaffold.dart';

class ForceUpdateWidget extends StatelessWidget {
  final AppProvider appProvider;

  const ForceUpdateWidget({Key key, this.appProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AppScaffold(
      hasCurve: true,
      bgColor: AppColors.white,
      bgImage: "assets/images/page-bg-pattern-white.png",
      bodyPadding: const EdgeInsets.symmetric(horizontal: 17.0),
      body: Column(
        children: [
          SizedBox(height: screenSize.height * 0.2),
          getUpperImage(screenSize),
          const SizedBox(height: 50),
          getDialogTitle(),
          const SizedBox(height: 10),
          getDialogContent(),
          const SizedBox(height: 30),
          AppButtons.primary(
            onPressed: () {
              if (appProvider.bootConfigs.data['clear_local_storage'] != null && appProvider.bootConfigs.data['clear_local_storage'] == 1) {
                print("appProvider.bootConfigs.data['clear_local_storage']");
                print(appProvider.bootConfigs.data['clear_local_storage']);
                LocalStorage().clear();
              }

              String appPackageName;
              var androidStoreLinkPackage = appProvider.bootConfigs.data['android_store_link_package'];
              if (androidStoreLinkPackage != null) {
                print("appProvider.bootConfigs.data['android_store_link_package']");
                appPackageName = androidStoreLinkPackage;
                print(appPackageName);
              }

              String iosAppId;
              String appleStoreLinkAppId = appProvider.bootConfigs.data['apple_store_link_app_id'];
              if (appleStoreLinkAppId != null && appleStoreLinkAppId.isNotEmpty) {
                print("appProvider.bootConfigs.data['apple_store_link_app_id']");
                iosAppId = appleStoreLinkAppId;
                print(iosAppId);
              }
              LaunchReview.launch(androidAppId: appPackageName, iOSAppId: iosAppId);
            },
            child: Text("Open Store"),
          )
        ],
      ),
    );
  }

  Text getDialogTitle() {
    String text = "Update Required";
    if (appProvider.bootConfigs.dataTranslated?.dialog != null) text = appProvider.bootConfigs.dataTranslated.dialog.title;
    return Text(text, style: AppTextStyles.h1);
  }

  Text getDialogContent() {
    String text = "Please update the application from the store";
    if (appProvider.bootConfigs.dataTranslated?.dialog != null) text = appProvider.bootConfigs.dataTranslated.dialog.content;
    return Text(
      text,
      style: AppTextStyles.body,
      textAlign: TextAlign.center,
    );
  }

  Image getUpperImage(Size screenSize) {
    return appProvider.bootConfigs.data['image'] != null
        ? Image.network(
            appProvider.bootConfigs.data['image'],
            width: screenSize.width / 2.5,
          )
        : Image.asset(
            'assets/images/tiptop-logo.png',
            width: screenSize.width / 2.5,
          );
  }
}
