import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/food_home_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_carousel.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/no_content_view.dart';
import 'package:tiptop_v2/UI/widgets/address/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/cart/app_bar_cart_total.dart';
import 'package:tiptop_v2/UI/widgets/channels_buttons.dart';
import 'package:tiptop_v2/UI/widgets/home_live_tracking.dart';
import 'package:tiptop_v2/UI/widgets/market/home_categories_grid.dart';
import 'package:tiptop_v2/dummy_data.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
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

  bool hasActiveOrders = false;
  bool hideContent = false;

  Future<void> fetchAndSetHomeData() async {
    try {
      setState(() => isLoadingHomeData = true);
      await addressesProvider.fetchSelectedAddress();
      await homeProvider.fetchAndSetHomeData(context, appProvider, cartProvider, addressesProvider);
      if (homeProvider.selectedChannel == 'grocery') {
        marketHomeData = homeProvider.marketHomeData;
        marketCategories = marketHomeData.categories;
        marketSlides = marketHomeData.slides;
        hasActiveOrders =
            appProvider.isAuth && homeProvider.marketHomeData.activeOrders != null && homeProvider.marketHomeData.activeOrders.length > 0;
        hideContent = homeProvider.homeDataRequestError || homeProvider.marketNoBranchFound;
      } else {
        foodHomeData = homeProvider.foodHomeData;
        foodCategories = dummyFoodCategories;
        foodSlides = foodHomeData.slides;
        // hideContent = homeProvider.homeDataRequestError || homeProvider.foodNoBranchFound;
      }
      setState(() => isLoadingHomeData = false);
    } catch (e) {
      //Todo: translate this string/reconsider what to do
      showToast(msg: 'An Error Occurred! Please try again later');
      setState(() => isLoadingHomeData = false);
      throw e;
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
                    hideContent || isLoadingHomeData
                        ? Container(
                            height: homeSliderHeight,
                            color: AppColors.bg,
                          )
                        : AppCarousel(
                            images: homeProvider.selectedChannel == 'grocery'
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
                    if (homeProvider.selectedChannel == 'food')
                      FoodHomePage(
                        foodHomeData: foodHomeData,
                        isLoadingHomeData: isLoadingHomeData,
                      ),
                    if (homeProvider.selectedChannel == 'grocery')
                      Column(
                        children: [
                          if (hasActiveOrders)
                            HomeLiveTracking(
                              isRTL: appProvider.isRTL,
                              activeOrders: homeProvider.marketHomeData.activeOrders,
                              totalActiveOrders: homeProvider.marketHomeData.totalActiveOrders,
                            ),
                          hideContent
                              ? NoContentView(
                                  text: homeProvider.marketNoBranchFound
                                      ? 'No Branch Found'
                                      : homeProvider.homeDataRequestError
                                          ? 'An error occurred! Please try again later'
                                          : '')
                              : isLoadingHomeData
                                  ? const AppLoader()
                                  : HomeCategoriesGrid(
                                      categories: marketCategories,
                                      fetchAndSetHomeData: fetchAndSetHomeData,
                                      isLoadingHomeData: isLoadingHomeData,
                                    ),
                        ],
                      ),
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
