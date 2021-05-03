import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/food_search_page.dart';
import 'package:tiptop_v2/UI/pages/home_page.dart';
import 'package:tiptop_v2/UI/pages/market/market_search_page.dart';
import 'package:tiptop_v2/UI/pages/profile/profile_page.dart';
import 'package:tiptop_v2/UI/pages/support_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/cart/cart_fab.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AppWrapper extends StatefulWidget {
  static const routeName = '/app-wrapper';

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final CupertinoTabController _cupertinoTabController = CupertinoTabController();
  int currentTabIndex = 0;
  HomeProvider homeProvider;

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

  List<BottomNavigationBarItem> _getCupertinoTabBarItems(bool isRTL) {
    List<Map<String, dynamic>> _cupertinoTabsList = _getCupertinoTabsList();
    double tabWidth = MediaQuery.of(context).size.width / _cupertinoTabsList.length;

    return List.generate(_cupertinoTabsList.length, (i) {
      int tabWithEndPaddingIndex = (_cupertinoTabsList.length / 2).ceil() - 1;
      int tabWithStartPaddingIndex = (_cupertinoTabsList.length / 2).ceil() + 1 - 1;

      return BottomNavigationBarItem(
        backgroundColor: AppColors.primary,
        icon: Padding(
          padding: i == tabWithEndPaddingIndex
              ? isRTL
                  ? EdgeInsets.only(left: tabWidth / 2)
                  : EdgeInsets.only(right: tabWidth / 2)
              : i == tabWithStartPaddingIndex
                  ? isRTL
                      ? EdgeInsets.only(right: tabWidth / 2)
                      : EdgeInsets.only(left: tabWidth / 2)
                  : EdgeInsets.all(0),
          child: Icon(
            _cupertinoTabsList[i]['icon'],
          ),
        ),
      );
    });
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      homeProvider = Provider.of<HomeProvider>(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  static List<Map<String, dynamic>> _getCupertinoTabsList({bool channelIsMarket = true}) {
    return [
      {
        'title': 'Home',
        'page': HomePage(),
        'icon': LineAwesomeIcons.home,
      },
      {
        'title': 'Search',
        'page': channelIsMarket ? MarketSearchPage() : FoodSearchPage(),
        'icon': LineAwesomeIcons.search,
      },
      {
        'title': 'Support',
        'page': SupportPage(),
        'icon': LineAwesomeIcons.headset,
      },
      {
        'title': 'Profile',
        'page': ProfilePage(),
        'icon': LineAwesomeIcons.user_cog,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid ? !await currentNavigatorKey().currentState.maybePop() : null;
      },
      child: Stack(
        children: [
          Consumer<AppProvider>(
            builder: (c, appProvider, _) => CupertinoTabScaffold(
              backgroundColor: AppColors.white,
              controller: _cupertinoTabController,
              tabBar: CupertinoTabBar(
                onTap: (index) => onTabItemTapped(index),
                currentIndex: currentTabIndex,
                backgroundColor: AppColors.primary,
                activeColor: AppColors.secondary,
                inactiveColor: AppColors.white.withOpacity(0.5),
                items: _getCupertinoTabBarItems(appProvider.isRTL),
              ),
              tabBuilder: (BuildContext context, int index) {
                return CupertinoTabView(
                  navigatorKey: _tabNavKeys[index],
                  builder: (BuildContext context) {
                    return _getCupertinoTabsList(channelIsMarket: homeProvider.channelIsMarket)[index]['page'];
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
          CartFAB(),
        ],
      ),
    );
  }
}
