import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/food/cart/food_cart_fab.dart';
import 'package:tiptop_v2/UI/widgets/market/cart/market_cart_fab.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/food_provider.dart';
import 'package:tiptop_v2/providers/market_provider.dart';
import 'package:tiptop_v2/providers/one_signal_notifications_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/cupertino_tabbar_helper.dart';
import 'package:tiptop_v2/utils/deeplinks_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:uni_links/uni_links.dart';

//Widget that sets up the app's OneSignal & DeepLinks listeners
//And returns the requested Food/Market channel
class AppWrapper extends StatefulWidget {
  final AppChannel targetAppChannel;
  final bool forceFoodHomeDataRefresh;
  final bool forceMarketHomeDataRefresh;

  // static const routeName = '/app-wrapper';

  AppWrapper({
    @required this.targetAppChannel,
    this.forceFoodHomeDataRefresh = false,
    this.forceMarketHomeDataRefresh = false,
  });

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  AppProvider appProvider;
  StreamSubscription _deepLinksSubscription;
  OneSignalNotificationsProvider oneSignalNotificationsProvider;
  StreamSubscription<OSNotificationPayload> _oneSignalListener;

  bool _isInit = true;
  FoodProvider foodProvider;
  MarketProvider marketProvider;
  ProductsProvider productsProvider;
  AddressesProvider addressesProvider;
  bool forceFoodHomeDataRefresh = false;
  bool forceMarketHomeDataRefresh = false;

  Future<void> _fetchAndSetHomeData() async {
    await addressesProvider.fetchSelectedAddress();
    if (widget.targetAppChannel == AppChannel.FOOD) {
      if (foodProvider.foodHomeData == null || forceFoodHomeDataRefresh) {
        await foodProvider.fetchAndSetFoodHomeData(context, appProvider);
        forceFoodHomeDataRefresh = false;
      }
    } else {
      if (marketProvider.marketHomeData == null || forceMarketHomeDataRefresh) {
        await marketProvider.fetchAndSetMarketHomeData(context, appProvider);
        forceMarketHomeDataRefresh = false;
      }
    }
  }

  final CupertinoTabController _cupertinoTabController = CupertinoTabController();
  int currentTabIndex = 0;
  List<GlobalKey<NavigatorState>> _tabNavKeys = List.generate(initCupertinoTabsList.length, (i) => GlobalKey<NavigatorState>());

  GlobalKey<NavigatorState> currentNavigatorKey() {
    return _tabNavKeys[_cupertinoTabController.index];
  }

  void onTabItemTapped(int index) {
    if (_tabNavKeys[index].currentState != null && currentTabIndex == index) {
      _tabNavKeys[index].currentState.popUntil((r) => r.isFirst);
    }
    _cupertinoTabController.index = index;
    currentTabIndex = index;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context);
      marketProvider = Provider.of<MarketProvider>(context, listen: widget.targetAppChannel == AppChannel.MARKET);
      foodProvider = Provider.of<FoodProvider>(context, listen: widget.targetAppChannel == AppChannel.FOOD);
      productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      oneSignalNotificationsProvider = Provider.of<OneSignalNotificationsProvider>(context);

      forceFoodHomeDataRefresh = widget.forceFoodHomeDataRefresh;
      forceMarketHomeDataRefresh = widget.forceMarketHomeDataRefresh;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchAndSetHomeData().then((_) {
          // Check if a deeplink exists
          // (this only happen when the app was shutdown and not running in the background)
          if (appProvider.initialUri != null) {
            print("👽👽👽👽👽👽👽👽👽👽 Got a deep link in app launch! 👽👽👽👽👽👽👽👽👽👽");
            runDeepLinkAction(context, appProvider.initialUri, appProvider.isAuth);
            //Clear deeplink from app provider to prevent it from running again when this page is accessed again
            appProvider.setInitialUri(null);
          }

          if (widget.targetAppChannel == AppChannel.MARKET || forceMarketHomeDataRefresh) {
            productsProvider.setMarketParentCategoriesWithoutChildren(marketProvider.marketParentCategoriesWithoutChildren);
            productsProvider.fetchAndSetParentCategoriesAndProducts();
          }

          _deepLinksSubscription = uriLinkStream.listen((Uri uri) {
            print("Got a deeeeep deep link from subscription: 💩💩💩💩💩💩💩");
            if (uri != null) {
              print('uri: $uri');
              runDeepLinkAction(context, uri, appProvider.isAuth);
            }
            // Use the uri and warn the user, if it is not correct
          }, onError: (err) {
            print('Error while listening to deeplink stream!');
            print('@e $err');
            // Handle exception by warning the user their action did not succeed
          });
        });

        if (oneSignalNotificationsProvider != null && oneSignalNotificationsProvider.getPayload != null) {
          oneSignalNotificationsProvider.initOneSignal();
          if (appProvider.isAuth && appProvider.authUser != null) {
            oneSignalNotificationsProvider.handleSetExternalUserId(appProvider.authUser.id.toString());
          }

          _oneSignalListener = oneSignalNotificationsProvider.getPayload.listen(null);
          _oneSignalListener.onData((event) {
            print("Is opened: ${OneSignalNotificationsProvider.notificationHasOpened}");
            if (event != null && event.additionalData != null && event.additionalData.length > 0) {
              // print(event.additionalData.keys.toString());
              // DeepLink coming from notifications
              if (event.additionalData['deep_link'] != null) {
                runDeepLinkAction(context, Uri.parse(event.additionalData['deep_link']), appProvider.isAuth);
                oneSignalNotificationsProvider.clearPayload();
              }
            }
          });
        }

        if (appProvider.isFirstOpen) {
          appProvider.setIsFirstOpen(false);
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _deepLinksSubscription.cancel();
    _oneSignalListener.cancel();
    _cupertinoTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilt app wrapper");
    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid ? !await currentNavigatorKey().currentState.maybePop() : null;
      },
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: widget.targetAppChannel == AppChannel.FOOD ? foodProvider.isLoadingFoodHomeData : marketProvider.isLoadingMarketHomeData,
            child: CupertinoTabScaffold(
              backgroundColor: AppColors.white,
              controller: _cupertinoTabController,
              tabBar: CupertinoTabBar(
                onTap: (index) => onTabItemTapped(index),
                currentIndex: currentTabIndex,
                backgroundColor: AppColors.primary,
                activeColor: AppColors.secondary,
                inactiveColor: AppColors.white.withOpacity(0.5),
                items: getCupertinoTabBarItems(
                  context: context,
                  isRTL: appProvider.isRTL,
                ),
              ),
              tabBuilder: (BuildContext context, int index) {
                return CupertinoTabView(
                  navigatorKey: _tabNavKeys[index],
                  builder: (BuildContext context) {
                    List<TabItem> cupertinoTabListItems = getCupertinoTabsList(
                      widget.targetAppChannel,
                      forceFoodHomeDataRefresh: forceFoodHomeDataRefresh,
                      forceMarketHomeDataRefresh: forceMarketHomeDataRefresh,
                    );
                    return cupertinoTabListItems[index].view;
                  },
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (context) => AppScaffold(),
                    );
                  },
                );
              },
            ),
          ),
          widget.targetAppChannel == AppChannel.FOOD ? FoodCartFAB() : MarketCartFAB(),
        ],
      ),
    );
  }
}
