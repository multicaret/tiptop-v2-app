import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/cart_page.dart';
import 'package:tiptop_v2/UI/pages/home_page.dart';
import 'package:tiptop_v2/UI/pages/profile_page.dart';
import 'package:tiptop_v2/UI/pages/search_page.dart';
import 'package:tiptop_v2/UI/pages/support_page.dart';
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

  void onTabItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
      _cupertinoTabController.index = index;
      print(_selectedTabIndex);
    });
  }

  List<BottomNavigationBarItem> _getCupertinoTabBarItems() {
    return List.generate(_cupertinoTabsList.length, (i) {
      return BottomNavigationBarItem(
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
      'page': CartPage(),
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

  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (c, homeProvider, _) => CupertinoTabScaffold(
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
    );
  }
}
