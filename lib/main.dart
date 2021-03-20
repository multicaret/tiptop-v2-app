import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/language_select_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/providers.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/local_storage.dart';
import 'package:tiptop_v2/routes.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'UI/app_wrapper.dart';
import 'UI/splash_screen.dart';
import 'i18n/translations.dart';

void main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    LocalStorage().isReady().then((_) async {
      // Uncomment when you want to clear local storage on app launch
      // LocalStorage().clear();
      AppProvider appProvider = AppProvider();
      await appProvider.fetchLocale();
      runApp(MyApp(
        appProvider: appProvider,
      ));
    });
  }, (e, _) => throw e);
}

class MyApp extends StatefulWidget {
  final AppProvider appProvider;

  MyApp({this.appProvider});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _autoLoginFuture;

  @override
  void initState() {
    _autoLoginFuture = widget.appProvider.autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: widget.appProvider,
        ),
        ...providers,
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
          supportedLocales: app.appLanguages.map((language) => Locale(language['locale'], language['country_code'])).toList(),
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
                elevation: 4,
                shadowColor: AppColors.shadowDark,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          home: app.localeSelected
              ? app.isAuth
                  ? AppWrapper()
                  : FutureBuilder(
                      future: _autoLoginFuture,
                      builder: (c, authResultSnapshot) =>
                          authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : WalkthroughPage(),
                    )
              : LanguageSelectPage(),
          routes: routes,
        ),
      ),
    );
  }
}
