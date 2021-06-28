import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/market/market_home_page.dart';
import 'package:tiptop_v2/UI/pages/market/market_search_page.dart';
import 'package:tiptop_v2/UI/pages/profile/profile_page.dart';
import 'package:tiptop_v2/UI/pages/support_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/market/cart/market_cart_fab.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/market_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/cupertino_tabbar_helper.dart';
import 'package:tiptop_v2/utils/deeplinks_helper.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

class MarketWrapper extends StatefulWidget {
  @override
  _MarketWrapperState createState() => _MarketWrapperState();
}

class _MarketWrapperState extends State<MarketWrapper> {
  final CupertinoTabController _cupertinoTabController = CupertinoTabController();
  int currentTabIndex = 0;
  bool _isInit = true;

  AppProvider appProvider;
  MarketProvider marketProvider;
  ProductsProvider productsProvider;
  AddressesProvider addressesProvider;

  Future<void> _fetchAndSetMarketHomeAndProductsData() async {
    await addressesProvider.fetchSelectedAddress();
    if (marketProvider.marketHomeData == null) {
      await marketProvider.fetchAndSetMarketHomeData(context, appProvider);
      productsProvider.setMarketParentCategoriesWithoutChildren(marketProvider.marketParentCategoriesWithoutChildren);
      await productsProvider.fetchAndSetParentCategoriesAndProducts();
    }
  }

  List<GlobalKey<NavigatorState>> _tabNavKeys = List.generate(_getCupertinoTabsList().length, (i) => GlobalKey<NavigatorState>());

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

  static List<Map<String, dynamic>> _getCupertinoTabsList() {
    return [
      {
        'title': 'home',
        'page': MarketHomePage(),
        'icon': LineAwesomeIcons.home,
      },
      {
        'title': 'Search',
        'page': MarketSearchPage(),
        'icon': LineAwesomeIcons.search,
      },
      {
        'title': 'Support',
        'page': SupportPage(asTab: true),
        'icon': LineAwesomeIcons.headset,
      },
      {
        'title': 'Profile',
        'page': ProfilePage(currentChannel: AppChannel.MARKET),
        'icon': LineAwesomeIcons.user_cog,
      },
    ];
  }

  EventTracking eventTracking = EventTracking.getActions();

  Future<void> trackMarketHomeViewEvent() async {
    Map<String, dynamic> eventParams = {
      'screen': appChannelRealValues.reverse[AppChannel.MARKET],
    };
    await eventTracking.trackEvent(TrackingEvent.VIEW_HOME, eventParams);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      marketProvider = Provider.of<MarketProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context);
      productsProvider = Provider.of<ProductsProvider>(context);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchAndSetMarketHomeAndProductsData().then((_) {
          // Check if a deeplink exists
          // (this only happen when the app was shutdown and not running in the background)
          if (appProvider.initialUri != null) {
            runDeepLinkAction(context, appProvider.initialUri, appProvider.isAuth);
            //Clear deeplink from app provider to prevent it from running again when this page is accessed again
            appProvider.setInitialUri(null);
          }

          trackMarketHomeViewEvent();
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _cupertinoTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilt Market Wrapper!");

    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid ? !await currentNavigatorKey().currentState.maybePop() : null;
      },
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: marketProvider.isLoadingMarketHomeData,
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
                    Map<String, dynamic> cupertinoTabListItem = _getCupertinoTabsList()[index];
                    return cupertinoTabListItem['page'];
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
          MarketCartFAB(),
        ],
      ),
    );
  }
}
