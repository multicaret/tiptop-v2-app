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

  EstimatedArrivalTime estimatedArrivalTime;
  List<Category> categories = [];
  List<Slide> slides = [];

  String currentView = 'market';

  Future<void> fetchAndSetHomeData() async {
    try {
      setState(() => isLoadingHomeData = true);
      await addressesProvider.fetchSelectedAddress();
      await homeProvider.fetchAndSetHomeData(context, appProvider, cartProvider, addressesProvider);
      estimatedArrivalTime = homeProvider.homeData.estimatedArrivalTime;
      categories = homeProvider.homeData.categories;
      slides = homeProvider.homeData.slides;
      setState(() => isLoadingHomeData = false);
    } catch (e) {
      //Todo: translate this string/reconsider what to do
      showToast(msg: 'An Error Occurred! Please try again later');
      setState(() => isLoadingHomeData = false);
      throw e;
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
      bodyPadding: EdgeInsets.all(0),
      body: Consumer<HomeProvider>(
        builder: (c, homeProvider, _) {
          bool hideContent = homeProvider.homeDataRequestError || homeProvider.noBranchFound;
          return Column(
            children: [
              AddressSelectButton(isLoadingHomeData: isLoadingHomeData),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: fetchAndSetHomeData,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 50.0),
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
                                images: slides.map((slide) => slide.image).toList(),
                                autoplayDuration: Duration(milliseconds: 300),
                                autoPlayInterval: Duration(seconds: 7),
                                // mapWidget: MapSlide(selectedAddress: addressesProvider.selectedAddress),
                              ),
                        //Todo: switch whole app when Food infrastructure is set up
                        ChannelsButtons(
                          currentView: currentView,
                          changeView: (value) => setState(() => currentView = value),
                          isRTL: appProvider.isRTL,
                        ),
                        if (currentView == 'food') FoodHomePage(),
                        if (currentView == 'market')
                          Column(
                            children: [
                              if (!isLoadingHomeData && homeProvider.homeData.activeOrders != null && homeProvider.homeData.activeOrders.length > 0)
                                HomeLiveTracking(
                                  isRTL: appProvider.isRTL,
                                  activeOrders: homeProvider.homeData.activeOrders,
                                  totalActiveOrders: homeProvider.homeData.totalActiveOrders,
                                ),
                              hideContent
                                  ? NoContentView(
                                      text: homeProvider.noBranchFound
                                          ? 'No Branch Found'
                                          : homeProvider.homeDataRequestError
                                              ? 'An error occurred! Please try again later'
                                              : '')
                                  : isLoadingHomeData
                                      ? AppLoader()
                                      : HomeCategoriesGrid(
                                          categories: categories,
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
          );
        },
      ),
    );
  }
}
