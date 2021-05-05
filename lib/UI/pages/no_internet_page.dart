import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class NoInternetPage extends StatefulWidget {
  final AppProvider appProvider;

  NoInternetPage({@required this.appProvider});

  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool _isLoadingConnectivityCheck = false;
  bool _animationLoaded = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              child: Lottie.asset(
                'assets/images/no-internet-lottie.json',
                // repeat: false,
                fit: BoxFit.cover,
                width: double.infinity,
                onLoaded: (_) => setState(() => _animationLoaded = true),
              ),
            ),
            if (_animationLoaded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        Translations.of(context).get("Please check your internet connection then try again!"),
                        style: AppTextStyles.h2.copyWith(height: 1.7),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppButtons.primary(
                      child: _isLoadingConnectivityCheck
                          ? SpinKitThreeBounce(
                              color: AppColors.white,
                              size: 20,
                            )
                          : Text(Translations.of(context).get("Try Again")),
                      onPressed: () async {
                        setState(() => _isLoadingConnectivityCheck = true);
                        await widget.appProvider.bootActions();
                        if (widget.appProvider.noInternet) {
                          showToast(msg: Translations.of(context).get("You are still not connected to the internet!"));
                        }
                        setState(() => _isLoadingConnectivityCheck = false);
                      },
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
