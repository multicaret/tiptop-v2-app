import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/food/food_home_page_view.dart';
import 'package:tiptop_v2/UI/pages/market/market_home_page_view.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';

class HomePage extends StatefulWidget {
  final AppChannel targetAppChannel;
  final Function marketDeepLinkAction;
  final Function foodDeepLinkAction;
  final ValueChanged<AppChannel> switchAppWrapperChannel;

  HomePage({
    @required this.targetAppChannel,
    this.marketDeepLinkAction,
    this.foodDeepLinkAction,
    this.switchAppWrapperChannel,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EventTracking eventTracking = EventTracking.getActions();
  AppProvider appProvider;

  PageController _pageViewController;
  AppChannel currentChannel;

  List<Widget> _pages;

  List<Widget> _getPages() {
    return [
      FoodHomePageView(
        onChannelSwitch: () {
          _pageViewController.animateToPage(
            1,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
          widget.switchAppWrapperChannel(AppChannel.MARKET);
        },
        foodDeepLinkAction: widget.foodDeepLinkAction,
      ),
      MarketHomePageView(
        onChannelSwitch: () {
          _pageViewController.animateToPage(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
          widget.switchAppWrapperChannel(AppChannel.FOOD);
        },
        marketDeepLinkAction: widget.marketDeepLinkAction,
      ),
    ];
  }

  @override
  void initState() {
    _pageViewController = PageController(initialPage: widget.targetAppChannel == AppChannel.FOOD ? 0 : 1);
    _pages = _getPages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      child: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageViewController,
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return _pages[index];
        },
        onPageChanged: (int index) {
          currentChannel = index == 0 ? AppChannel.FOOD : AppChannel.MARKET;
        },
      ),
    );
  }
}
