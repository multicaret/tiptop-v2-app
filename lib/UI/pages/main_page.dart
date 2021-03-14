import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/screens/home_screen.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/cart_items_count_badge.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/home-page';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin<MainPage> {
  int currentTabIndex = 0;

  @override
  bool get wantKeepAlive => true;

  static List<Map<String, dynamic>> tabsList = [
    {
      'title': 'Categories',
      'screen': HomeScreen(),
      'icon': Icons.category,
    },
    {
      'title': 'Offers',
      'screen': Center(child: Text('Tab 2')),
      'icon': Icons.list,
    },
    {
      'title': 'Appointments',
      'screen': Center(child: Text('Cart')),
      'icon': Icons.shopping_cart,
    },
    {
      'title': 'Profile',
      'screen': Center(child: Text('Tab 4')),
      'icon': Icons.person,
    },
    {
      'title': 'Profile',
      'screen': Center(child: Text('Tab 5')),
      'icon': Icons.settings,
    },
  ];

  List<TabItem> _getTabItems() {
    return List.generate(tabsList.length, (i) {
      return TabItem(
        icon: tabsList[i]['icon'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppScaffold(
      bodyPadding: EdgeInsets.all(0),
      automaticallyImplyLeading: false,
/*      body: DefaultTabController(
        length: tabsList.length,
        child: TabBarView(
          children: [...tabsList.map((tab) => tab['screen'])],
        ),
      ),*/
      body: tabsList[currentTabIndex]['screen'],
      bottomNavigationBar: ConvexAppBar.badge(
        {
          //Cart badge
          2: CartItemsCountBadge(),
        },
        backgroundColor: AppColors.primary,
        style: TabStyle.fixedCircle,
        items: _getTabItems(),
        initialActiveIndex: 1,
        onTap: (int i) {
          setState(() {
            currentTabIndex = i;
          });
        },
      ),
    );
  }
}
