import 'package:flutter/cupertino.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tiptop_v2/UI/pages/food/food_home_page.dart';
import 'package:tiptop_v2/UI/pages/food/food_search_page.dart';
import 'package:tiptop_v2/UI/pages/market/market_home_page.dart';
import 'package:tiptop_v2/UI/pages/market/market_search_page.dart';
import 'package:tiptop_v2/UI/pages/profile/profile_page.dart';
import 'package:tiptop_v2/UI/pages/support_page.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

List<TabItem> initCupertinoTabsList = [
  TabItem(
    id: 0,
    icon: LineAwesomeIcons.home,
  ),
  TabItem(
    id: 1,
    icon: LineAwesomeIcons.search,
  ),
  TabItem(
    id: 2,
    icon: LineAwesomeIcons.headset,
  ),
  TabItem(
    id: 3,
    icon: LineAwesomeIcons.user_cog,
  ),
];

List<TabItem> getCupertinoTabsList(
  AppChannel targetAppChannel, {
  bool forceMarketHomeDataRefresh = false,
  bool forceFoodHomeDataRefresh = false,
}) {
  return initCupertinoTabsList.map((tabItem) {
    switch (tabItem.id) {
      case 0:
        return TabItem(
          id: tabItem.id,
          icon: tabItem.icon,
          view: targetAppChannel == AppChannel.FOOD
              ? FoodHomePage(forceMarketHomeDataRefresh: forceMarketHomeDataRefresh)
              : MarketHomePage(forceFoodHomeDataRefresh: forceFoodHomeDataRefresh),
        );
        break;
      case 1:
        return TabItem(
          id: tabItem.id,
          icon: tabItem.icon,
          view: targetAppChannel == AppChannel.FOOD ? FoodSearchPage() : MarketSearchPage(),
        );
        break;
      case 2:
        return TabItem(
          id: tabItem.id,
          icon: tabItem.icon,
          view: SupportPage(asTab: true),
        );
        break;
      case 3:
        return TabItem(
          id: tabItem.id,
          icon: tabItem.icon,
          view: ProfilePage(currentChannel: targetAppChannel),
        );
        break;
    }
  }).toList();
}

List<BottomNavigationBarItem> getCupertinoTabBarItems({
  BuildContext context,
  bool isRTL,
}) {
  double tabWidth = MediaQuery.of(context).size.width / initCupertinoTabsList.length;

  return List.generate(initCupertinoTabsList.length, (i) {
    int tabWithEndPaddingIndex = (initCupertinoTabsList.length / 2).ceil() - 1;
    int tabWithStartPaddingIndex = (initCupertinoTabsList.length / 2).ceil() + 1 - 1;

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
          initCupertinoTabsList[i].icon,
        ),
      ),
    );
  });
}
