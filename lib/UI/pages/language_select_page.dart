import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class LanguageSelectPage extends StatelessWidget {
  static const routeName = '/language-select';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    AppProvider appProvider = Provider.of<AppProvider>(context);
    List<Language> appLanguages = appProvider.appLanguages;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/page-bg-pattern-white.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tiptop-logo.png',
              width: screenSize.width / 2.5,
            ),
            const SizedBox(height: 67),
            ..._languageItems(context, appLanguages, appProvider),
          ],
        ),
      ),
    );
  }
}

List<Widget> _languageItems(
  BuildContext context,
  List<Language> _appLanguages,
  AppProvider appProvider,
) {
  return List.generate(_appLanguages.length, (i) {
    return Container(
      padding: EdgeInsets.only(bottom: i == _appLanguages.length - 1 ? 0 : 15),
      child: AppButtons.secondary(
        onPressed: () {
          appProvider.changeLanguage(_appLanguages[i].locale);
          //Todo: remove this when profile screen has language selection
          if (appProvider.localeSelected) {
            Navigator.of(context).pushNamed(AppWrapper.routeName);
          }
        },
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            Expanded(
              child: Image(
                alignment: Alignment.centerRight,
                image: AssetImage(_appLanguages[i].logo),
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(width: 25),
            Expanded(
              child: Text(
                _appLanguages[i].title,
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
      ),
    );
  });
}
