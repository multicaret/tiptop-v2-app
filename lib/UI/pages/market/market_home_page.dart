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
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/market_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import '../../app_wrapper.dart';

class MarketHomePage extends StatelessWidget {
  final bool forceFoodHomeDataRefresh;

  MarketHomePage({this.forceFoodHomeDataRefresh = false});

  @override
  Widget build(BuildContext context) {
    print("Rebuilt Market Home Page!");

    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer2<AppProvider, MarketProvider>(
        builder: (c, appProvider, marketProvider, _) {
          bool hideMarketContent = marketProvider.isLoadingMarketHomeData ||
              marketProvider.marketHomeData == null ||
              marketProvider.marketHomeDataRequestError ||
              marketProvider.marketNoBranchFound;

          return AppScaffold(
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
                    onRefresh: () => marketProvider.fetchAndSetMarketHomeData(context, appProvider),
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
                            onPressed: marketProvider.isLoadingMarketHomeData
                                ? () {}
                                : (AppChannel _channel) => pushAndRemoveUntilCupertinoPage(
                                      context,
                                      AppWrapper(
                                        targetAppChannel: _channel,
                                        forceFoodHomeDataRefresh: forceFoodHomeDataRefresh,
                                      ),
                                    ),
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
          );
        },
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
}
