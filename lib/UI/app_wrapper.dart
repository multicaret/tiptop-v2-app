import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/food_search_page.dart';
import 'package:tiptop_v2/UI/pages/home_page.dart';
import 'package:tiptop_v2/UI/pages/profile/profile_page.dart';
import 'package:tiptop_v2/UI/pages/market/market_search_page.dart';
import 'package:tiptop_v2/UI/pages/support_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/cart/cart_fab.dart';
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

  List<BottomNavigationBarItem> _getCupertinoTabBarItems(HomeProvider homeProvider) {
    List<Map<String, dynamic>> _cupertinoTabsList = _getCupertinoTabsList(homeProvider);
    return List.generate(_cupertinoTabsList.length, (i) {
      return BottomNavigationBarItem(
        backgroundColor: AppColors.primary,
        icon: Icon(
          _cupertinoTabsList[i]['icon'],
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
        'title': 'Cart',
        'page': AppScaffold(body: Container()),
        'icon': LineAwesomeIcons.shopping_cart,
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
    return Consumer<HomeProvider>(
      child: CartFAB(),
      builder: (c, homeProvider, child) => WillPopScope(
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
                items: _getCupertinoTabBarItems(homeProvider),
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
