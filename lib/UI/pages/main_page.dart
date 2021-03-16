import 'dart:io' show Platform;

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/screens/home_screen.dart';
import 'package:tiptop_v2/UI/screens/products_screen.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/cart_items_count_badge.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main-page';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin<MainPage> {
  int currentTabIndex = 0;

  @override
  bool get wantKeepAlive => true;

  List<TabItem> _getTabItems(HomeProvider homeProvider) {
    List<Map<String, dynamic>> tabsList = _getTabsList(homeProvider);

    return List.generate(tabsList.length, (i) {
      return TabItem(
        icon: i == 0
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    currentTabIndex = i;
                  });
                  homeProvider.selectCategory(null);
                },
                child: Icon(
                  tabsList[i]['icon'],
                  color: currentTabIndex == 0 ? Colors.white : Colors.white30,
                ),
              )
            : Icon(
                tabsList[i]['icon'],
                color: i == 2
                    ? AppColors.secondaryDark
                    : currentTabIndex == i
                        ? Colors.white
                        : Colors.white30,
                size: i == 2 ? 40 : 25,
              ),
      );
    });
  }

  List<Map<String, dynamic>> _getTabsList(HomeProvider homeProvider) {
    return [
      {
        'title': 'Home',
        'screen': homeProvider.categorySelected
            ? ProductsScreen(
                parents: homeProvider.categories,
                selectedParentCategoryId: homeProvider.selectedParentCategoryId,
              )
            : HomeScreen(),
        'icon': LineAwesomeIcons.home,
      },
      {
        'title': 'Offers',
        'screen': Center(child: Text('Tab 2')),
        'icon': LineAwesomeIcons.search,
      },
      {
        'title': 'Appointments',
        'screen': Center(child: Text('Cart')),
        'icon': LineAwesomeIcons.shopping_cart,
      },
      {
        'title': 'Profile',
        'screen': Center(child: Text('Tab 4')),
        'icon': LineAwesomeIcons.headset,
      },
      {
        'title': 'Profile',
        'screen': Center(child: Text('Tab 5')),
        'icon': LineAwesomeIcons.user_cog,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<HomeProvider>(
      builder: (c, homeProvider, _) => AppScaffold(
        hasCurve: !homeProvider.categorySelected,
        appBar: currentTabIndex == 0 && homeProvider.categorySelected
            ? AppBar(
                automaticallyImplyLeading: false,
                title: Text(Translations.of(context).get('Products')),
                leading: IconButton(
                  onPressed: () => homeProvider.selectCategory(null),
                  icon: Icon(Platform.isAndroid ? Icons.arrow_back : CupertinoIcons.back),
                ),
              )
            : null,
        bodyPadding: EdgeInsets.all(0),
        automaticallyImplyLeading: false,
        body: _getTabsList(homeProvider)[currentTabIndex]['screen'],
        bottomNavigationBar: ConvexAppBar.badge(
          {
            //Cart badge
            2: CartItemsCountBadge(),
          },
          backgroundColor: AppColors.primary,
          style: TabStyle.fixedCircle,
          color: Colors.white30,
          items: _getTabItems(homeProvider),
          onTap: (int i) {
            setState(() {
              currentTabIndex = i;
            });
          },
        ),
      ),
    );
  }
}
