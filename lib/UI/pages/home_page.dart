import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_carousel.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/no_content_view.dart';
import 'package:tiptop_v2/UI/widgets/address/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/cart/app_bar_cart_total.dart';
import 'package:tiptop_v2/UI/widgets/channels_buttons.dart';
import 'package:tiptop_v2/UI/widgets/food/food_home_content.dart';
import 'package:tiptop_v2/UI/widgets/home_live_tracking.dart';
import 'package:tiptop_v2/UI/widgets/market/market_home_categories_grid.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/one_signal_notifications_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  OneSignalNotificationsProvider _oneSignalNotificationsProvider;
  StreamSubscription<OSNotificationPayload> _listener;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool _isInit = true;

  AppProvider appProvider;
  HomeProvider homeProvider;

  HomeData marketHomeData;
  HomeData foodHomeData;
  List<Slide> marketSlides = [];
  List<Slide> foodSlides = [];

  bool hasActiveMarketOrders = false;
  List<Order> activeMarketOrders = [];

  bool hasActiveFoodOrders = false;
  List<Order> activeFoodOrders = [];

  bool hideMarketContent = false;
  bool hideFoodContent = false;

  Future<void> fetchAndSetHomeData() async {
    await homeProvider.fetchAndSetHomeData(context, appProvider);
    _setHomeData();
  }

  void _setHomeData() {
    if (homeProvider.channelIsMarket) {
      hideMarketContent = homeProvider.marketHomeData == null || homeProvider.marketHomeDataRequestError || homeProvider.marketNoBranchFound;
      if (!hideMarketContent) {
        marketHomeData = homeProvider.marketHomeData;
        marketSlides = marketHomeData.slides;
        hasActiveMarketOrders =
            appProvider.isAuth && homeProvider.marketHomeData.activeOrders != null && homeProvider.marketHomeData.activeOrders.length > 0;
        activeMarketOrders = hasActiveMarketOrders ? homeProvider.marketHomeData.activeOrders : [];
      }
    } else {
      hideFoodContent = homeProvider.foodHomeData == null || homeProvider.foodHomeDataRequestError || homeProvider.foodNoRestaurantFound;
      if (!hideFoodContent) {
        print('Setting food data in home page!');
        foodHomeData = homeProvider.foodHomeData;
        foodSlides = foodHomeData.slides;
        hasActiveFoodOrders =
            appProvider.isAuth && homeProvider.foodHomeData.activeOrders != null && homeProvider.foodHomeData.activeOrders.length > 0;
        activeFoodOrders = hasActiveFoodOrders ? homeProvider.foodHomeData.activeOrders : [];
      }
    }
  }

  void channelButtonAction(String _channel) {
    homeProvider.setSelectedChannel(_channel);
    if ((_channel == 'food' && foodHomeData == null) || (_channel == 'grocery' && marketHomeData == null)) {
      fetchAndSetHomeData();
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchAndSetHomeData();
      });
      _oneSignalNotificationsProvider = Provider.of<OneSignalNotificationsProvider>(context);
      if (_oneSignalNotificationsProvider != null && _oneSignalNotificationsProvider.getPayload != null) {
        _oneSignalNotificationsProvider.initOneSignal();
        _listener = _oneSignalNotificationsProvider.getPayload.listen(null);
        _listener.onData((event) {
          print("Is opened: ${OneSignalNotificationsProvider.notificationHasOpened}");
          print(event.additionalData.keys.toString());
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarActions: appProvider.isAuth ? [AppBarCartTotal()] : null,
      bodyPadding: const EdgeInsets.all(0),
      hasOverlayLoader: homeProvider.isLoadingHomeData,
      body: Column(
        children: [
          AddressSelectButton(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => fetchAndSetHomeData(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 50.0),
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    hideMarketContent || homeProvider.isLoadingHomeData
                        ? Container(
                            height: homeSliderHeight,
                            color: AppColors.bg,
                          )
                        : AppCarousel(
                            images: homeProvider.channelIsMarket
                                ? marketSlides.map((slide) => slide.image).toList()
                                : foodSlides.map((slide) => slide.image).toList(),
                            autoplayDuration: const Duration(milliseconds: 300),
                            autoPlayInterval: const Duration(seconds: 7),
                          ),
                    ChannelsButtons(
                      currentView: homeProvider.selectedChannel,
                      onPressed: (value) => homeProvider.isLoadingHomeData ? {} : channelButtonAction(value),
                      isRTL: appProvider.isRTL,
                    ),
                    _homeContent(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeContent() {
    if (homeProvider.isLoadingHomeData) {
      //Display nothing when data is loading
      return Container();
    } else if (homeProvider.selectedChannel == 'grocery') {
      if (hideMarketContent) {
        //No Content View for market channel
        return NoContentView(
            text: homeProvider.marketNoBranchFound
                ? 'No Branch Found'
                : homeProvider.marketHomeDataRequestError
                    ? 'An error occurred! Please try again later'
                    : '');
      } else {
        //Market/Grocery channel home content
        return Column(
          children: [
            if (hasActiveMarketOrders)
              HomeLiveTracking(
                isRTL: appProvider.isRTL,
                activeOrders: homeProvider.marketHomeData.activeOrders,
                totalActiveOrders: homeProvider.marketHomeData.totalActiveOrders,
              ),
            MarketHomeCategoriesGrid(
              categories: homeProvider.marketCategories,
              fetchAndSetHomeData: fetchAndSetHomeData,
            ),
          ],
        );
      }
    } else if (homeProvider.selectedChannel == 'food') {
      if (hideMarketContent) {
        //No Content View for food channel
        return NoContentView(
            text: homeProvider.foodNoRestaurantFound
                ? 'No Open Restaurant Found!'
                : homeProvider.foodHomeDataRequestError
                    ? 'An error occurred! Please try again later'
                    : '');
      } else {
        //Food channel home content
        return Column(
          children: [
            if (hasActiveFoodOrders)
              HomeLiveTracking(
                isRTL: appProvider.isRTL,
                activeOrders: homeProvider.foodHomeData.activeOrders,
                totalActiveOrders: homeProvider.foodHomeData.totalActiveOrders,
              ),
            FoodHomeContent(
              foodHomeData: homeProvider.foodHomeData,
              isRTL: appProvider.isRTL,
            ),
          ],
        );
      }
    } else {
      return Container();
    }
  }
}
