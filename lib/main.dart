import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/language_select_page.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/routes.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'i18n/translations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AppProvider(),
        ),
        // ...providers,
      ],
      child: Consumer<AppProvider>(
        builder: (c, app, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TipTop',
          localizationsDelegates: [
            Translations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: app.appLocal,
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('ar', ''),
            const Locale('ku', ''),
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: AppColors.primary,
            accentColor: AppColors.secondary,
            scaffoldBackgroundColor: Colors.transparent,
            fontFamily: 'NeoSansArabic',
            textTheme: TextTheme(
              headline1: AppTextStyles.h2,
              button: AppTextStyles.button,
              bodyText1: AppTextStyles.body,
              bodyText2: AppTextStyles.body, //Default style everywhere, e.g. Text widget
            ),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              textTheme: TextTheme(
                headline1: AppTextStyles.h2,
                headline6: AppTextStyles.h2,
                bodyText1: AppTextStyles.body,
              ),
              iconTheme: IconThemeData(color: AppColors.primary, size: 20),
              actionsIconTheme: IconThemeData(color: AppColors.primary, size: 20),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: AppColors.primary,
                onPrimary: AppColors.white,
                minimumSize: Size.fromHeight(55),
                textStyle: AppTextStyles.button,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          home: LanguageSelectPage(),
          routes: routes,
        ),
      ),
    );
  }
}
