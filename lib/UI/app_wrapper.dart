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
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/one_signal_notifications_provider.dart';
import 'package:tiptop_v2/utils/cupertino_tabbar_helper.dart';
import 'package:tiptop_v2/utils/deeplinks_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:uni_links/uni_links.dart';

class AppWrapper extends StatefulWidget {
  final AppChannel targetAppChannel;
  final Function marketDeepLinkAction;
  final Function foodDeepLinkAction;

  // static const routeName = '/app-wrapper';

  AppWrapper({
    @required this.targetAppChannel,
    this.marketDeepLinkAction,
    this.foodDeepLinkAction,
  });

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _isInit = true;
  AppProvider appProvider;
  OneSignalNotificationsProvider oneSignalNotificationsProvider;
  StreamSubscription<OSNotificationPayload> _oneSignalListener;
  StreamSubscription _deepLinksSubscription;

  //Cupertino Tab Bar Code
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

  //End Cupertino Tab Bar Code

  AppChannel currentAppChannel;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      print("Reran didChangeDependencies in app wrapper");
      appProvider = Provider.of<AppProvider>(context);
      oneSignalNotificationsProvider = Provider.of<OneSignalNotificationsProvider>(context, listen: false);
      currentAppChannel = widget.targetAppChannel;

      _deepLinksSubscription = uriLinkStream.listen((Uri uri) {
        print("Got a deeeeep deep link from subscription: 💩💩💩💩💩💩💩");
        if (uri != null) {
          print('uri: $uri');
          runDeepLinkAction(
            context,
            uri,
            appProvider.isAuth,
            currentChannel: currentAppChannel,
          );
        }
        // Use the uri and warn the user, if it is not correct
      }, onError: (err) {
        print('Error while listening to deeplink stream!');
        print('@e $err');
        // Handle exception by warning the user their action did not succeed
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
              runDeepLinkAction(
                context,
                Uri.parse(event.additionalData['deep_link']),
                appProvider.isAuth,
                currentChannel: currentAppChannel,
              );
              oneSignalNotificationsProvider.clearPayload();
            }
          }
        });
      }

      if (appProvider.isFirstOpen) {
        appProvider.setIsFirstOpen(false);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _cupertinoTabController.dispose();
    _deepLinksSubscription.cancel();
    _oneSignalListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("🥷🏽 🥷🏽 🥷🏽 🥷🏽 🥷🏽 🥷🏽 🥷🏽 🥷🏽 Rebuilt app wrapper 🥷🏽 🥷🏽 🥷🏽 🥷🏽 🥷🏽 🥷🏽 🥷🏽 🥷🏽");
    print('currentAppChannel');
    print(currentAppChannel);

    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid ? !await currentNavigatorKey().currentState.maybePop() : null;
      },
      child: Stack(
        children: [
          IgnorePointer(
            // ignoring: widget.targetAppChannel == AppChannel.FOOD ? foodProvider.isLoadingFoodHomeData : marketProvider.isLoadingMarketHomeData,
            ignoring: false,
            child: CupertinoTabScaffold(
              backgroundColor: AppColors.white,
              controller: _cupertinoTabController,
              tabBar: CupertinoTabBar(
                onTap: (index) => onTabItemTapped(index),
                currentIndex: currentTabIndex,
                backgroundColor: AppColors.primary,
                activeColor: AppColors.secondary,
                inactiveColor: AppColors.white.withOpacity(0.5),
                items: getCupertinoTabBarItems(context),
              ),
              tabBuilder: (BuildContext context, int index) {
                return CupertinoTabView(
                  navigatorKey: _tabNavKeys[index],
                  builder: (BuildContext context) {
                    List<TabItem> cupertinoTabListItems = getCupertinoTabsList(
                      currentAppChannel,
                      switchAppWrapperChannel: (AppChannel _selectedAppChannel) {
                        setState(() {
                          currentAppChannel = _selectedAppChannel;
                        });
                      },
                      foodDeepLinkAction: widget.foodDeepLinkAction,
                      marketDeepLinkAction: widget.marketDeepLinkAction,
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
          currentAppChannel == AppChannel.FOOD ? FoodCartFAB() : MarketCartFAB(),
        ],
      ),
    );
  }
}
