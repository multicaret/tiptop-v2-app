import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/food/cart/food_cart_fab.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/cupertino_tabbar_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class FoodApp extends StatefulWidget {
  final Function onChannelSwitch;
  final Function foodDeepLinkAction;

  FoodApp({
    @required this.onChannelSwitch,
    this.foodDeepLinkAction,
  });

  @override
  _FoodAppState createState() => _FoodAppState();
}

class _FoodAppState extends State<FoodApp> with AutomaticKeepAliveClientMixin {
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

  @override
  void dispose() {
    _cupertinoTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                      AppChannel.FOOD,
                      // onChannelSwitch: widget.onChannelSwitch,
                      foodDeepLinkAction: widget.foodDeepLinkAction,
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
          FoodCartFAB(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
