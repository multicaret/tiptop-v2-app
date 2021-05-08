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
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';
import 'package:uni_links/uni_links.dart';

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
  StreamSubscription _deepLinksSubscription;

  Future<void> _initEventTracking() async {
    await eventTracking.initEventTracking();

    //Send app visit event
    Map<String, dynamic> visitEventParams = {
      'platform': widget.appProvider.mobileAppDetails['device']['platform'],
      'user_language': widget.appProvider.appLocale.languageCode,
    };
    await eventTracking.trackEvent(TrackingEvent.VISIT, visitEventParams);

    // Attach a listener to the stream
    _deepLinksSubscription = uriLinkStream.listen((Uri uri) {
      print("Got a deeeeep deep link: 💩💩💩💩💩💩💩");
      if (uri != null) {
        String mainAction = uri.host;
        var params = uri.queryParametersAll;
        String uriChannel = params['channel'] as String;
        String itemId = params['id'] as String;
        String itemParentId = params['parent_id'] as String;
        // Some Flags
        bool hasId = itemId != null;
        bool hasParentId = itemParentId != null;
        bool hasChannel = uriChannel != null;
        if (mainAction != null) {
          switch (mainAction) {
            case "blog_index":
              // Todo: Open Blog page:
              print("Open Blog page:");
              break;
            case "blog_show":
              if (hasId) {
                // Todo: Open Blog show page: using {itemId}
                print("Open Blog show page: using {itemId}");
              }
              break;
            case "favorites":
              if (hasChannel) {
                // Todo: Open Favorites page: using {uriChannel}
                print("Open Favorites page: using {uriChannel}");
              }
              break;
            case "addresses":
              // Todo: Open Addresses page
              print("Open Addresses page");
              break;
            case "home_screen_by_channel":
              if (hasChannel) {
                // Todo: Open Home page: using {uriChannel}
                print("Open Home page: using {uriChannel}");
              }
              break;
            case "market_food_category_show":
              if (hasChannel && hasId && hasParentId) {
                // Todo: Open Food Branch scroll to category: using: { uriChannel, itemId, itemParentId}
                print("Open Food Branch scroll to category: using: { uriChannel, itemId, itemParentId}");
                // OR
                // Todo: Open Category Market scroll to category: using: { uriChannel, itemId, itemParentId}
                print("Open Category Market scroll to category: using: { uriChannel, itemId, itemParentId}");
              }
              break;
            case "order_rating":
              if (hasId) {
                // Todo: Open Order Rating screen: using: {itemId}
                print("Open Order Rating screen: using: {itemId}");
              }
              break;
            case "order_tracking":
              if (hasId) {
                // Todo: Open Order Tracking screen: using: {itemId}
                print("Open Order Tracking screen: using: {itemId}");
              }
              break;
            case "previous_orders":
              if (hasChannel) {
                // Todo: Open Previous Orders page: using {uriChannel}
                print("Open Previous Orders page: using {uriChannel}");
              }
              break;
            case "product_show":
              if (hasId && hasChannel) {
                // Todo: Open Product Show screen: using {itemId,hasChannel}
                print("Open Product Show screen: using {itemId,hasChannel}");
              }
              break;
          }
        }
      }
      // Use the uri and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
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
    _deepLinksSubscription.cancel();
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
