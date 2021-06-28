import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/no_content_view.dart';
import 'package:tiptop_v2/UI/widgets/channels_buttons.dart';
import 'package:tiptop_v2/UI/widgets/food/cart/food_app_bar_cart_total.dart';
import 'package:tiptop_v2/UI/widgets/food/food_address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/food/food_home_content.dart';
import 'package:tiptop_v2/UI/widgets/food/food_home_slider.dart';
import 'package:tiptop_v2/UI/widgets/home_live_tracking.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/food_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import '../../app_wrapper.dart';

class FoodHomePage extends StatelessWidget {
  final bool forceMarketHomeDataRefresh;

  FoodHomePage({this.forceMarketHomeDataRefresh = false});

  @override
  Widget build(BuildContext context) {
    print("Rebuilt Food Home Page!");

    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer2<AppProvider, FoodProvider>(
        builder: (c, appProvider, foodProvider, _) {
          bool hideFoodContent = foodProvider.isLoadingFoodHomeData ||
              foodProvider.foodHomeData == null ||
              foodProvider.foodHomeDataRequestError ||
              foodProvider.foodNoRestaurantFound;

          return AppScaffold(
            appBarActions: appProvider.isAuth
                ? [
                    FoodAppBarCartTotal(
                      isLoading: foodProvider.isLoadingFoodHomeData,
                      requestError: foodProvider.foodHomeDataRequestError,
                      isRTL: appProvider.isRTL,
                    ),
                  ]
                : null,
            bodyPadding: const EdgeInsets.all(0),
            hasOverlayLoader: foodProvider.isLoadingFoodHomeData,
            body: Column(
              children: [
                FoodAddressSelectButton(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => foodProvider.fetchAndSetFoodHomeData(context, appProvider),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          hideFoodContent
                              ? Container(
                                  height: homeSliderHeight,
                                  color: AppColors.bg,
                                )
                              : FoodHomeSlider(slides: foodProvider.foodHomeData.slides),
                          ChannelsButtons(
                            selectedChannel: AppChannel.FOOD,
                            onPressed: foodProvider.isLoadingFoodHomeData
                                ? () {}
                                : (AppChannel _channel) => pushAndRemoveUntilCupertinoPage(
                                      context,
                                      AppWrapper(
                                        targetAppChannel: _channel,
                                        forceMarketHomeDataRefresh: forceMarketHomeDataRefresh,
                                      ),
                                    ),
                            isRTL: appProvider.isRTL,
                          ),
                          _foodHomeContent(
                            foodProvider: foodProvider,
                            hideFoodContent: hideFoodContent,
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

  Widget _foodHomeContent({
    @required FoodProvider foodProvider,
    @required bool hideFoodContent,
    @required bool isAuth,
  }) {
    bool hasActiveFoodOrders = !hideFoodContent && isAuth && foodProvider.foodHomeData.activeOrders.length > 0;

    if (foodProvider.isLoadingFoodHomeData) {
      //Display nothing when data is loading
      return Container();
    } else {
      if (hideFoodContent) {
        //No Content View for food channel
        return NoContentView(
            text: foodProvider.foodNoRestaurantFound
                ? foodProvider.foodNoAvailabilityMessage
                : foodProvider.foodHomeDataRequestError
                    ? 'An error occurred! Please try again later'
                    : '');
      } else {
        //Food channel home content
        return Column(
          children: [
            if (hasActiveFoodOrders)
              HomeLiveTracking(
                activeOrders: foodProvider.foodHomeData.activeOrders,
                totalActiveOrders: foodProvider.foodHomeData.totalActiveOrders,
                channelIsFood: true,
              ),
            if (foodProvider.foodHomeData != null)
              FoodHomeContent(
                foodHomeData: foodProvider.foodHomeData,
              ),
          ],
        );
      }
    }
  }
}
