import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/language_select_page.dart';
import 'package:tiptop_v2/UI/pages/no_internet_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/providers.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/local_storage.dart';
import 'package:tiptop_v2/routes.dart';
import 'package:tiptop_v2/utils/adjust.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';

import 'UI/app_wrapper.dart';
import 'UI/pages/force_update_page.dart';
import 'UI/pages/location_permission_page.dart';
import 'UI/splash_screen.dart';
import 'i18n/translations.dart';
import 'models/enums.dart';

void main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    LocalStorage().isReady().then((_) async {
      // Uncomment when you want to clear local storage on app launch
      // LocalStorage().clear();
      // LocalStorage().deleteData(key: 'selected_address');
      AppProvider appProvider = AppProvider();
      appProvider.initInstaBug();
      appProvider.initAdjust();
      await appProvider.bootActions();
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<void> _autoLoginFuture;
  EventTracking eventTracking = EventTracking.getActions();

  Future<void> _initEventTracking() async {
    await eventTracking.initEventTracking();

    //Send app visit event
    Map<String, dynamic> visitEventParams = {
      'platform': widget.appProvider.mobileAppDetails['device']['platform'],
      'user_language': widget.appProvider.appLocale.languageCode,
    };
    await eventTracking.trackEvent(TrackingEvent.VISIT, visitEventParams);
  }

  @override
  void initState() {
    _autoLoginFuture = widget.appProvider.autoLogin();
    WidgetsBinding.instance.addObserver(this);
    getDeepLinkUrlFromPlugin();

    super.initState();

    //Init tracking services
    _initEventTracking();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        //Todo: track visit event again???
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
    // Todo: To get fresh data on all states
    print('state = $state');
    getDeepLinkUrlFromPlugin();
  }

  // Todo: Move this class to somewhere else
  Future<void> getDeepLinkUrlFromPlugin() async {
    String deepLinkUrl;
    try {
      deepLinkUrl = await DeepLinkPlugin.getUrl;
    } on PlatformException {
      deepLinkUrl = 'Error on init deep link plugin';
    }
    if (!mounted) return;

    print("got a deeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeep link:");
    print(deepLinkUrl);
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
          locale: app.appLocale,
          supportedLocales: app.appLanguages.map((language) => Locale(language.locale, language.countryCode)).toList(),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: AppColors.primary,
            accentColor: AppColors.secondaryLight,
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
            sliderTheme: SliderThemeData(
              showValueIndicator: ShowValueIndicator.onlyForContinuous,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
              tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 6.0),
              activeTickMarkColor: AppColors.primary,
              activeTrackColor: AppColors.primary,
              inactiveTickMarkColor: AppColors.primary50,
              inactiveTrackColor: AppColors.primary50,
              thumbColor: AppColors.primary,
              valueIndicatorColor: AppColors.secondary,
              disabledInactiveTrackColor: AppColors.primary50,
              disabledActiveTickMarkColor: AppColors.primary,
              disabledInactiveTickMarkColor: AppColors.primary50,
              disabledActiveTrackColor: AppColors.primary,
              disabledThumbColor: AppColors.primary,
            ),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: AppColors.primary, textStyle: AppTextStyles.textButton)),
          ),
          home: getHomeWidget(app),
          routes: routes,
        ),
      ),
    );
  }

  Widget getHomeWidget(AppProvider app) {
    if (app.noInternet) {
      return NoInternetPage(
        appProvider: app,
      );
    } else {
      if (app.isForceUpdateEnabled) {
        return ForceUpdatePage(
          appProvider: app,
        );
      }
      return app.localeSelected
          ? app.isAuth
              ? !app.isLocationPermissionGranted
                  ? LocationPermissionPage()
                  : AppWrapper()
              : FutureBuilder(
                  future: _autoLoginFuture,
                  builder: (c, authResultSnapshot) =>
                      authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : WalkthroughPage(),
                )
          : LanguageSelectPage();
    }
  }
}
