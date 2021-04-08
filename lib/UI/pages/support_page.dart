import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  static const routeName = '/support';

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  bool _isLoading = false;
  AppProvider appProvider;
  String phoneNumber = '';

  Future<void> _fetchAndSetSupportPhoneNumber() async {
    setState(() => _isLoading = true);
    try {
      final responseData = await appProvider.get(endpoint: 'support');
      phoneNumber = responseData["data"]["supportNumber"];
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      throw e;
    }
  }

  @override
  void initState() {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    _fetchAndSetSupportPhoneNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyPadding: const EdgeInsets.symmetric(horizontal: 17),
      bgColor: AppColors.white,
      bgImage: "assets/images/page-bg-pattern-white.png",
      appBar: AppBar(
        title: Text(Translations.of(context).get('Support')),
      ),
      body: _isLoading
          ? const AppLoader()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Translations.of(context).get('We are at your service 24/7. Please contact us via'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: AppButtons.secondaryXl(
                          onPressed: () {
                            launch('tel://$phoneNumber');
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                FontAwesomeIcons.phoneAlt,
                                color: AppColors.primary,
                                size: 50,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                Translations.of(context).get('Direct Call'),
                                style: AppTextStyles.body,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButtons.primaryXl(
                          onPressed: () {
                            // Navigator.of(context, rootNavigator: true).pushNamed(LiveChatPage.routeName);
                          },
                          child: Column(
                            children: [
                              Icon(
                                FontAwesomeIcons.solidCommentDots,
                                color: AppColors.white,
                                size: 50,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                Translations.of(context).get('Live Chat'),
                                style: AppTextStyles.bodyWhite,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
