import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/track_food_order_page.dart';
import 'package:tiptop_v2/UI/pages/market/order/market_previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/market/order/track_market_order_page.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'UI/app_cached_network_image.dart';
import 'address/address_icon.dart';

class HomeLiveTracking extends StatelessWidget {
  final List<Order> activeOrders;
  final int totalActiveOrders;
  final bool channelIsFood;

  HomeLiveTracking({
    @required this.activeOrders,
    @required this.totalActiveOrders,
    this.channelIsFood = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      //ExpansionTile is showing the color of this container behind the children container when expanding
      padding: const EdgeInsets.only(right: screenHorizontalPadding, left: screenHorizontalPadding, top: 10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [const BoxShadow(blurRadius: 7, color: AppColors.shadow)],
          borderRadius: BorderRadius.circular(8.0),
          // color: AppColors.secondary,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            accentColor: AppColors.primary,
            // unselectedWidgetColor: AppColors.primary,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ExpansionTile(
              backgroundColor: AppColors.secondaryLight,
              collapsedBackgroundColor: AppColors.secondaryLight,
              childrenPadding: const EdgeInsets.all(0),
              initiallyExpanded: true,
              leading: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: Center(
                  child: Text('$totalActiveOrders', style: AppTextStyles.subtitleBold),
                ),
              ),
              title: Text(Translations.of(context).get("Live Order(s)"), style: AppTextStyles.bodyBold),
              children: [
                ...List.generate(activeOrders.length, (i) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border(bottom: BorderSide(color: AppColors.border)),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        channelIsFood
                            ? Consumer<AppProvider>(
                                child: AppCachedNetworkImage(
                                  imageUrl: activeOrders[i].branchLogo,
                                  width: addressIconSize,
                                ),
                                builder: (c, appProvider, child) => Container(
                                  padding: EdgeInsets.only(
                                    right: appProvider.isRTL ? 0 : 10,
                                    left: appProvider.isRTL ? 10 : 0,
                                  ),
                                  margin: EdgeInsets.only(
                                    right: appProvider.isRTL ? 0 : 10,
                                    left: appProvider.isRTL ? 10 : 0,
                                  ),
                                  child: child,
                                ),
                              )
                            : AddressIcon(
                                isAsset: false,
                                icon: activeOrders[i].address.kind.icon,
                              ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                channelIsFood ? activeOrders[i].branchName : Translations.of(context).get("Address"),
                                style: AppTextStyles.subtitleBold,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (!channelIsFood)
                                Row(
                                  children: [
                                    Text(
                                      activeOrders[i].address.kind.title,
                                      style: AppTextStyles.subtitle,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        activeOrders[i].address.address1,
                                        style: AppTextStyles.subtitle50,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: AppButtons.primarySm(
                            onPressed: () => Navigator.of(context, rootNavigator: true).pushNamed(
                              channelIsFood ? TrackFoodOrderPage.routeName : TrackMarketOrderPage.routeName,
                              arguments: {
                                'order_id': activeOrders[i].id,
                              },
                            ),
                            child: Text(
                              Translations.of(context).get("Track Order"),
                              style: AppTextStyles.subtitleWhite,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
                if (totalActiveOrders > 4)
                  Consumer<AppProvider>(
                    builder: (c, appProvider, _) => TextButton(
                      onPressed: () => Navigator.of(context, rootNavigator: true)
                          .pushNamed(channelIsFood ? FoodPreviousOrdersPage.routeName : MarketPreviousOrdersPage.routeName),
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${Translations.of(context).get("View All")} ($totalActiveOrders)'),
                          const SizedBox(width: 5),
                          AppIcons.iconSm(appProvider.isRTL ? FontAwesomeIcons.chevronLeft : FontAwesomeIcons.chevronRight),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
