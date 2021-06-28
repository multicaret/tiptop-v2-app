import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/no_content_view.dart';
import 'package:tiptop_v2/UI/widgets/channels_buttons.dart';
import 'package:tiptop_v2/UI/widgets/home_live_tracking.dart';
import 'package:tiptop_v2/UI/widgets/market/cart/market_app_bar_cart_total.dart';
import 'package:tiptop_v2/UI/widgets/market/market_address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/market/market_home_categories_grid.dart';
import 'package:tiptop_v2/UI/widgets/market/market_home_slider.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/market_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class MarketHomePage extends StatefulWidget {
  final Function marketDeepLinkAction;
  final Function onChannelSwitch;

  MarketHomePage({this.marketDeepLinkAction, this.onChannelSwitch});

  @override
  _MarketHomePageState createState() => _MarketHomePageState();
}

class _MarketHomePageState extends State<MarketHomePage> with AutomaticKeepAliveClientMixin {
  AppProvider appProvider;
  MarketProvider marketProvider;
  AddressesProvider addressesProvider;
  ProductsProvider productsProvider;
  CartProvider cartProvider;

  bool _isInit = true;

  Future<void> _fetchAndSetMarketHomeData() async {
    await addressesProvider.fetchSelectedAddress();
    await marketProvider.fetchAndSetMarketHomeData(
      context: context,
      appProvider: appProvider,
      cartProvider: cartProvider,
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      marketProvider = Provider.of<MarketProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context);
      productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      cartProvider = Provider.of<CartProvider>(context);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchAndSetMarketHomeData().then((_) {
          // Check if a deeplink exists
          // (this only happen when the app was shutdown and not running in the background)
          if (widget.marketDeepLinkAction != null) {
            widget.marketDeepLinkAction();
          }
          productsProvider.setMarketParentCategoriesWithoutChildren(marketProvider.marketParentCategoriesWithoutChildren);
          productsProvider.fetchAndSetParentCategoriesAndProducts();
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("Rebuilt Market Home Page!");
    bool hideMarketContent = marketProvider.isLoadingMarketHomeData ||
        marketProvider.marketHomeData == null ||
        marketProvider.marketHomeDataRequestError ||
        marketProvider.marketNoBranchFound;

    return WillPopScope(
      onWillPop: () async => false,
      child: AppScaffold(
        appBarActions: appProvider.isAuth
            ? [
                MarketAppBarCartTotal(
                  isLoading: marketProvider.isLoadingMarketHomeData,
                  requestError: marketProvider.marketHomeDataRequestError,
                  isRTL: appProvider.isRTL,
                ),
              ]
            : null,
        bodyPadding: const EdgeInsets.all(0),
        hasOverlayLoader: marketProvider.isLoadingMarketHomeData,
        body: Column(
          children: [
            MarketAddressSelectButton(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchAndSetMarketHomeData,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      hideMarketContent
                          ? Container(
                              height: homeSliderHeight,
                              color: AppColors.bg,
                            )
                          : MarketHomeSlider(
                              slides: marketProvider.marketHomeData.slides,
                              delivery: marketProvider.marketHomeData.branch.tiptopDelivery,
                            ),
                      ChannelsButtons(
                        selectedChannel: AppChannel.MARKET,
                        onPressed: marketProvider.isLoadingMarketHomeData ? () {} : (AppChannel _channel) => widget.onChannelSwitch(),
                        isRTL: appProvider.isRTL,
                      ),
                      _marketHomeContent(
                        marketProvider: marketProvider,
                        hideMarketContent: hideMarketContent,
                        isAuth: appProvider.isAuth,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _marketHomeContent({
    @required MarketProvider marketProvider,
    @required bool hideMarketContent,
    @required bool isAuth,
  }) {
    bool hasActiveMarketOrders = !hideMarketContent && isAuth && marketProvider.marketHomeData.activeOrders.length > 0;

    if (marketProvider.isLoadingMarketHomeData) {
      //Display nothing when data is loading
      return Container();
    } else {
      if (hideMarketContent) {
        //No Content View for market channel
        return NoContentView(
          text: marketProvider.marketNoBranchFound
              ? marketProvider.marketNoAvailabilityMessage
              : marketProvider.marketHomeDataRequestError
                  ? 'An error occurred! Please try again later'
                  : '',
        );
      } else {
        //Market/Grocery channel home content
        return Column(
          children: [
            if (hasActiveMarketOrders)
              HomeLiveTracking(
                activeOrders: marketProvider.marketHomeData.activeOrders,
                totalActiveOrders: marketProvider.marketHomeData.totalActiveOrders,
              ),
            MarketHomeCategoriesGrid(
              parentCategories: marketProvider.marketParentCategoriesWithoutChildren,
            ),
          ],
        );
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
