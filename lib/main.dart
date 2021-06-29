import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:instabug_flutter/CrashReporting.dart';
import 'package:instabug_flutter/InstabugNavigatorObserver.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/language_select_page.dart';
import 'package:tiptop_v2/UI/pages/no_internet_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_themes.dart';
import 'package:tiptop_v2/providers.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/local_storage.dart';
import 'package:tiptop_v2/routes.dart';
import 'package:tiptop_v2/utils/deeplinks_helper.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';

import 'UI/app_wrapper.dart';
import 'UI/pages/force_update_page.dart';
import 'UI/splash_screen.dart';
import 'i18n/translations.dart';
import 'models/enums.dart';

void main() async {
  await runZonedGuarded<Future<void>>(() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    };

    WidgetsFlutterBinding.ensureInitialized();
    LocalStorage().isReady().then((_) async {
      // Uncomment when you want to clear local storage on app launch
      // LocalStorage().clear();
      // LocalStorage().deleteData(key: 'selected_address');
      AppProvider appProvider = AppProvider();
      appProvider.initInstaBug();
      await appProvider.bootActions();
      runApp(MyApp(
        appProvider: appProvider,
      ));
    });
  }, (e, s) {
    CrashReporting.reportCrash(e, s);
  });
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

  AppChannel targetChannelFromDeepLink;

  Future<void> _initEventTracking() async {
    final initialUri = await eventTracking.initEventTracking(widget.appProvider);
    if (initialUri != null) {
      targetChannelFromDeepLink = getDeepLinkChannel(initialUri);
      print('📺 📺 📺 📺 📺 📺 Requested channel from app launch deeplink: $targetChannelFromDeepLink 📺 📺 📺 📺 📺 📺');
    }

    //Send app visit event
    Map<String, dynamic> visitEventParams = {
      'platform': AppProvider.mobileAppDetails['device']['platform'],
      'user_language': widget.appProvider.appLocale.languageCode,
    };
    await eventTracking.trackEvent(TrackingEvent.VISIT, visitEventParams);
  }

  @override
  void initState() {
    _autoLoginFuture = widget.appProvider.autoLogin();
    WidgetsBinding.instance.addObserver(this);
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
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        Adjust.onPause();
        break;
    }
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
        builder: (c, appProvider, _) {
          return MaterialApp(
            navigatorObservers: [InstabugNavigatorObserver()],
            debugShowCheckedModeBanner: false,
            title: 'TipTop',
            localizationsDelegates: [
              Translations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: appProvider.appLocale,
            supportedLocales: appProvider.appLanguages.map((language) => Locale(language.locale, language.countryCode)).toList(),
            theme: AppThemes.mainTheme(appProvider.isRTL, appProvider.isKurdish),
            home: getHomeWidget(appProvider),
            routes: routes,
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                builder: (context) => Container(
                  color: Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget getHomeWidget(AppProvider appProvider) {
    if (appProvider.noInternet) {
      return NoInternetPage(
        appProvider: appProvider,
      );
    } else {
      if (appProvider.isForceUpdateEnabled || appProvider.isSoftUpdateEnabled) {
        return ForceUpdatePage(
          appProvider: appProvider,
          isSoftUpdateEnabled: appProvider.isSoftUpdateEnabled,
        );
      }
      if (!appProvider.localeSelected) {
        return LanguageSelectPage();
      }
      if (appProvider.isAuth) {
        return appProvider.isFirstOpen ? WalkthroughPage() : AppWrapper(targetAppChannel: targetChannelFromDeepLink ?? appProvider.appDefaultChannel);
      } else {
        return FutureBuilder(
          future: _autoLoginFuture,
          builder: (c, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting
              ? SplashScreen()
              : appProvider.isFirstOpen
                  ? WalkthroughPage()
                  : AppWrapper(targetAppChannel: targetChannelFromDeepLink ?? appProvider.appDefaultChannel),
        );
      }
    }
  }
}
