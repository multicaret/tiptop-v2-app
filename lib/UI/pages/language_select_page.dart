import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/main_page.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class LanguageSelectPage extends StatelessWidget {
  static const routeName = '/language-select';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    AppProvider appProvider = Provider.of<AppProvider>(context);
    List<Map<String, String>> appLanguages = appProvider.appLanguages;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        padding: EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/page-bg-pattern.png"),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tiptop-logo.png',
              width: screenSize.width / 2.5,
            ),
            SizedBox(height: 67),
            ..._languageItems(context, appLanguages, appProvider),
          ],
        ),
      ),
    );
  }
}

List<Widget> _languageItems(
  BuildContext context,
  List<Map<String, String>> _appLanguages,
  AppProvider appProvider,
) {
  HomeProvider homeProvider = Provider.of<HomeProvider>(context);

  return List.generate(_appLanguages.length, (i) {
    return Container(
      padding: EdgeInsets.only(bottom: i == _appLanguages.length - 1 ? 0 : 15),
      child: ElevatedButton(
        onPressed: () {
          appProvider.changeLanguage(_appLanguages[i]['locale']);
          homeProvider.selectCategory(null);
          //Todo: remove this when profile screen has language selection
          if(appProvider.localeSelected) {
            Navigator.of(context).pushNamed(MainPage.routeName);
          }
        },
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            Expanded(
              child: Image(
                alignment: Alignment.centerRight,
                image: AssetImage(_appLanguages[i]['flag']),
                width: 40,
                height: 40,
              ),
            ),
            SizedBox(width: 25),
            Expanded(
              child: Text(
                _appLanguages[i]['title'],
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: AppColors.secondary,
          onPrimary: AppColors.text,
          textStyle: AppTextStyles.body,
          side: BorderSide(color: AppColors.secondaryDark),
        ),
      ),
    );
  });
}
