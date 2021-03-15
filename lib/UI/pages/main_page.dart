import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tiptop_v2/UI/screens/home_screen.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
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
      'title': 'Home',
      'screen': HomeScreen(),
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

  List<TabItem> _getTabItems() {
    return List.generate(tabsList.length, (i) {
      return TabItem(
        icon: i == 2
            ? Icon(
                tabsList[i]['icon'],
                color: AppColors.secondaryDark,
                size: 40,
              )
            : tabsList[i]['icon'],
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
          // 2: CartItemsCountBadge(),
        },
        backgroundColor: AppColors.primary,
        style: TabStyle.fixedCircle,
        color: Colors.white30,
        items: _getTabItems(),
        onTap: (int i) {
          setState(() {
            currentTabIndex = i;
          });
        },
      ),
    );
  }
}
