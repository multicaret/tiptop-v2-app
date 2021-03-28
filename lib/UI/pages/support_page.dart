import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/pages/live_chat_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  static const routeName = '/support';

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      bgColor: AppColors.white,
      bgImage: "assets/images/page-bg-pattern-white.png",
      appBar: AppBar(
        title: Text(Translations.of(context).get('Support')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Translations.of(context).get('We are at your service 24/7, please contact us via'),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.secondaryDark,
                        minimumSize: Size.fromHeight(150),
                      ),
                      onPressed: () {
                        launch('phone number');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            FontAwesomeIcons.phoneAlt,
                            color: AppColors.primary,
                            size: 50,
                          ),
                          SizedBox(height: 15),
                          Text(
                            Translations.of(context).get('Direct Call'),
                            style: AppTextStyles.body,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primary,
                        minimumSize: Size.fromHeight(150),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(LiveChatPage.routeName);
                      },
                      child: Column(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidCommentDots,
                            color: AppColors.white,
                            size: 50,
                          ),
                          SizedBox(height: 15),
                          Text(
                            Translations.of(context).get('Live Chat'),
                            style: AppTextStyles.bodyWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
