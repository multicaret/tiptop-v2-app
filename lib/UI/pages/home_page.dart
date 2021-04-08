import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_carousel.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/no_content_view.dart';
import 'package:tiptop_v2/UI/widgets/address/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/cart/app_bar_cart_total.dart';
import 'package:tiptop_v2/UI/widgets/channels_buttons.dart';
import 'package:tiptop_v2/UI/widgets/food/food_home_content.dart';
import 'package:tiptop_v2/UI/widgets/home_live_tracking.dart';
import 'package:tiptop_v2/UI/widgets/market/market_home_categories_grid.dart';
import 'package:tiptop_v2/dummy_data.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isLoadingHomeData = false;
  bool _isInit = true;

  AppProvider appProvider;
  HomeProvider homeProvider;
  CartProvider cartProvider;
  AddressesProvider addressesProvider;

  HomeData marketHomeData;
  HomeData foodHomeData;
  List<Category> marketCategories = [];
  List<Category> foodCategories = [];
  List<Slide> marketSlides = [];
  List<Slide> foodSlides = [];

  bool hasActiveMarketOrders = false;
  List<Order> activeMarketOrders = [];

  bool hasActiveFoodOrders = false;
  List<Order> activeFoodOrders = [];

  bool hideMarketContent = false;
  bool hideFoodContent = false;

  Future<void> fetchAndSetHomeData() async {
    setState(() => isLoadingHomeData = true);
    await addressesProvider.fetchSelectedAddress();
    await homeProvider.fetchAndSetHomeData(context, appProvider, cartProvider, addressesProvider);
    _setHomeData();
    setState(() => isLoadingHomeData = false);
  }

  void _setHomeData() {
    if (homeProvider.channelIsMarket) {
      hideMarketContent = homeProvider.homeDataRequestError || homeProvider.marketNoBranchFound;
      if (!hideMarketContent) {
        marketHomeData = homeProvider.marketHomeData;
        marketCategories = marketHomeData.categories;
        marketSlides = marketHomeData.slides;
        hasActiveMarketOrders =
            appProvider.isAuth && homeProvider.marketHomeData.activeOrders != null && homeProvider.marketHomeData.activeOrders.length > 0;
        activeMarketOrders = hasActiveMarketOrders ? homeProvider.marketHomeData.activeOrders : [];
      }
    } else {
      hideFoodContent = homeProvider.homeDataRequestError || homeProvider.foodNoRestaurantFound;
      if (!hideFoodContent) {
        foodHomeData = homeProvider.foodHomeData;
        foodCategories = dummyFoodCategories;
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
      cartProvider = Provider.of<CartProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context);
      fetchAndSetHomeData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarActions: appProvider.isAuth ? [AppBarCartTotal(isLoadingHomeData: isLoadingHomeData)] : null,
      bodyPadding: const EdgeInsets.all(0),
      body: Column(
        children: [
          AddressSelectButton(isLoadingHomeData: isLoadingHomeData),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => fetchAndSetHomeData(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 50.0),
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    hideMarketContent || isLoadingHomeData
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
                            // mapWidget: MapSlide(selectedAddress: addressesProvider.selectedAddress),
                          ),
                    ChannelsButtons(
                      currentView: homeProvider.selectedChannel,
                      changeView: (value) => channelButtonAction(value),
                      isRTL: appProvider.isRTL,
                    ),
                    isLoadingHomeData
                        ? const AppLoader()
                        : homeProvider.channelIsMarket
                            ? hideMarketContent
                                ? NoContentView(
                                    text: homeProvider.marketNoBranchFound
                                        ? 'No Branch Found'
                                        : homeProvider.homeDataRequestError
                                            ? 'An error occurred! Please try again later'
                                            : '')
                                : Column(
                                    children: [
                                      if (hasActiveMarketOrders)
                                        HomeLiveTracking(
                                          isRTL: appProvider.isRTL,
                                          activeOrders: homeProvider.marketHomeData.activeOrders,
                                          totalActiveOrders: homeProvider.marketHomeData.totalActiveOrders,
                                        ),
                                      MarketHomeCategoriesGrid(
                                        categories: marketCategories,
                                        fetchAndSetHomeData: fetchAndSetHomeData,
                                        isLoadingHomeData: isLoadingHomeData,
                                      ),
                                    ],
                                  )
                            : homeProvider.selectedChannel == 'food'
                                ? Column(
                                    children: [
                                      if (hasActiveFoodOrders)
                                        HomeLiveTracking(
                                          isRTL: appProvider.isRTL,
                                          activeOrders: homeProvider.foodHomeData.activeOrders,
                                          totalActiveOrders: homeProvider.foodHomeData.totalActiveOrders,
                                        ),
                                      FoodHomeContent(
                                        foodHomeData: foodHomeData,
                                        isLoadingHomeData: isLoadingHomeData,
                                      ),
                                    ],
                                  )
                                : Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
