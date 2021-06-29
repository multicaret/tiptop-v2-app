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
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/food_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/deeplinks_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class FoodHomePageView extends StatefulWidget {
  final Function foodDeepLinkAction;
  final Function onChannelSwitch;

  FoodHomePageView({this.foodDeepLinkAction, this.onChannelSwitch});

  @override
  _FoodHomePageViewState createState() => _FoodHomePageViewState();
}

class _FoodHomePageViewState extends State<FoodHomePageView> with AutomaticKeepAliveClientMixin {
  bool _isInit = true;
  AppProvider appProvider;
  FoodProvider foodProvider;
  AddressesProvider addressesProvider;

  Future<void> _fetchAndSetFoodHomeData() async {
    await addressesProvider.fetchSelectedAddress();
    await foodProvider.fetchAndSetFoodHomeData(context, appProvider);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context, listen: false);
      foodProvider = Provider.of<FoodProvider>(context);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchAndSetFoodHomeData().then((_) {
          // Check if a deeplink exists
          // (this only happen when the app was shutdown and not running in the background)
          if (appProvider.initialUri != null) {
            print("👽👽👽👽👽👽👽👽👽👽 Got a deep link in app launch! 👽👽👽👽👽👽👽👽👽👽");
            runDeepLinkAction(
              context,
              appProvider.initialUri,
              appProvider.isAuth,
              currentChannel: AppChannel.FOOD,
            );
            //Clear deeplink from app provider to prevent it from running again when this page is accessed again
            appProvider.setInitialUri(null);
          }

          // Check if a deeplink exists
          // (this only happen when the app was shutdown and not running in the background
          // and it received a deeplink that needed the home page to run first)
          if (widget.foodDeepLinkAction != null) {
            widget.foodDeepLinkAction();
          }
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilt Food Home Page!");
    super.build(context);
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
                      onPressed: foodProvider.isLoadingFoodHomeData ? () {} : (AppChannel _channel) => widget.onChannelSwitch(),
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
                isRTL: appProvider.isRTL,
              ),
          ],
        );
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
