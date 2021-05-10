import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/pages/otp/otp_choose_method_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class WalkthroughPage extends StatefulWidget {
  static const routeName = '/walkthrough';

  @override
  _WalkthroughPageState createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  bool animationLoaded = false;

  bool _isInit = true;
  bool shouldPopOnly;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      shouldPopOnly = data != null && data["should_pop_only"] != null ? data["should_pop_only"] : false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyPadding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
      bgColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<AppProvider>(
              builder: (c, appProvider, _) {
                print(appProvider.appLocale.languageCode);
                return Container(
                  width: double.infinity,
                  child: Lottie.asset(
                    'assets/images/lottie-walkthrough/walkthrough-${appProvider.appLocale.languageCode}.json',
                    repeat: false,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    onLoaded: (_) => setState(() => animationLoaded = true),
                  ),
                );
              },
            ),
            if (animationLoaded)
              Container(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        getLocationPermissionStatus().then((isGranted) {
                          if (isGranted && !shouldPopOnly) {
                            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(AppWrapper.routeName, (Route<dynamic> route) => false);
                          } else if (isGranted && shouldPopOnly) {
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pushReplacementNamed(LocationPermissionPage.routeName);
                          }
                        });
                      },
                      child: Text(
                        Translations.of(context).get("Continue Without Login"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppButtons.primary(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(OTPChooseMethodPage.routeName);
                      },
                      child: Text(Translations.of(context).get("Register")),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(OTPChooseMethodPage.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Translations.of(context).get("Already have an account?")),
                          const SizedBox(width: 5),
                          Text(
                            Translations.of(context).get("Login"),
                            style: AppTextStyles.bodySecondaryDark,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
