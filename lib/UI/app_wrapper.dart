import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tiptop_v2/UI/pages/market/market_home_page.dart';
import 'package:tiptop_v2/UI/pages/profile/profile_page.dart';
import 'package:tiptop_v2/UI/pages/search_page.dart';
import 'package:tiptop_v2/UI/pages/support_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/cart/cart_fab.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AppWrapper extends StatefulWidget {
  static const routeName = '/app-wrapper';

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final CupertinoTabController _cupertinoTabController = CupertinoTabController();
  int currentTabIndex = 0;

  //The keys were added for android onBackPressed function (source: https://github.com/flutter/flutter/issues/24105)
  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fifthTabNavKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> currentNavigatorKey() {
    switch (_cupertinoTabController.index) {
      case 0:
        return firstTabNavKey;
        break;
      case 1:
        return secondTabNavKey;
        break;
      case 2:
        return thirdTabNavKey;
        break;
      case 3:
        return fourthTabNavKey;
        break;
      case 4:
        return fifthTabNavKey;
        break;
    }

    return null;
  }

  void onTabItemTapped(int index) {
    if (index == 2) {
      return;
    }
    _cupertinoTabController.index = index;
  }

  List<BottomNavigationBarItem> _getCupertinoTabBarItems() {
    return List.generate(_cupertinoTabsList.length, (i) {
      return BottomNavigationBarItem(
        backgroundColor: AppColors.primary,
        icon: Icon(
          _cupertinoTabsList[i]['icon'],
        ),
      );
    });
  }

  List<Map<String, dynamic>> _cupertinoTabsList = [
    {
      'title': 'Home',
      'page': HomePage(),
      'icon': LineAwesomeIcons.home,
    },
    {
      'title': 'Search',
      'page': SearchPage(),
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

  @override
  Widget build(BuildContext context) {
    print('Rebuilt app wrapper');
    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid ? !await currentNavigatorKey().currentState.maybePop() : null;
      },
      child: Stack(
        children: [
          CupertinoTabScaffold(
            backgroundColor: AppColors.white,
            controller: _cupertinoTabController,
            tabBar: CupertinoTabBar(
              onTap: onTabItemTapped,
              backgroundColor: AppColors.primary,
              activeColor: AppColors.secondaryDark,
              inactiveColor: AppColors.white.withOpacity(0.5),
              items: _getCupertinoTabBarItems(),
            ),
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return _cupertinoTabsList[index]['page'];
                },
              );
            },
          ),
          CartFAB(),
        ],
      ),
    );
  }
}
