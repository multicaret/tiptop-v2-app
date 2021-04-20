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

  List<GlobalKey<NavigatorState>> _getTabNavKeys(HomeProvider homeProvider) {
    return List.generate(_getCupertinoTabsList(homeProvider).length, (i) => GlobalKey<NavigatorState>());
  }

  GlobalKey<NavigatorState> currentNavigatorKey(HomeProvider homeProvider) {
    List<GlobalKey<NavigatorState>> _tabNavKeys = _getTabNavKeys(homeProvider);
    return _tabNavKeys[_cupertinoTabController.index];
  }

  void onTabItemTapped(int index) {
    if (index == 2) {
      return;
    }
    _cupertinoTabController.index = index;
  }

  List<BottomNavigationBarItem> _getCupertinoTabBarItems(HomeProvider homeProvider, bool isRTL) {
    List<Map<String, dynamic>> _cupertinoTabsList = _getCupertinoTabsList(homeProvider);
    double tabWidth = MediaQuery.of(context).size.width / _cupertinoTabsList.length;
    print('_cupertinoTabsList.length % 2');
    print(_cupertinoTabsList.length % 2);
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

  List<Map<String, dynamic>> _getCupertinoTabsList(HomeProvider homeProvider) {
    return [
      {
        'title': 'Home',
        'page': HomePage(),
        'icon': LineAwesomeIcons.home,
      },
      {
        'title': 'Search',
        'page': homeProvider.channelIsMarket ? MarketSearchPage() : FoodSearchPage(),
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
    // print('Rebuilt app wrapper');

    return Consumer2<HomeProvider, AppProvider>(
      child: CartFAB(),
      builder: (c, homeProvider, appProvider, child) => WillPopScope(
        onWillPop: () async {
          return Platform.isAndroid ? !await currentNavigatorKey(homeProvider).currentState.maybePop() : null;
        },
        child: Stack(
          children: [
            CupertinoTabScaffold(
              backgroundColor: AppColors.white,
              controller: _cupertinoTabController,
              tabBar: CupertinoTabBar(
                onTap: onTabItemTapped,
                backgroundColor: AppColors.primary,
                activeColor: AppColors.secondary,
                inactiveColor: AppColors.white.withOpacity(0.5),
                items: _getCupertinoTabBarItems(homeProvider, appProvider.isRTL),
              ),
              tabBuilder: (BuildContext context, int index) {
                return CupertinoTabView(
                  builder: (BuildContext context) {
                    return _getCupertinoTabsList(homeProvider)[index]['page'];
                  },
                );
              },
            ),
            child
          ],
        ),
      ),
    );
  }
}
