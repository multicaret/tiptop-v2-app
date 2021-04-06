import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/track_order_page.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'address/address_icon.dart';

class HomeLiveTracking extends StatelessWidget {
  final bool isRTL;
  final List<Order> activeOrders;

  HomeLiveTracking({
    @required this.isRTL,
    @required this.activeOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      //ExpansionTile is showing the color of this container behind the children container when expanding
      padding: EdgeInsets.only(right: 17, left: 17, top: 10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 7, color: AppColors.shadow)],
          borderRadius: BorderRadius.circular(8.0),
          // color: AppColors.secondaryDark,
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
              backgroundColor: AppColors.secondaryDark,
              collapsedBackgroundColor: AppColors.secondaryDark,
              childrenPadding: EdgeInsets.all(0),
              leading: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: Center(
                  child: Text('${activeOrders.length}', style: AppTextStyles.subtitleBold),
                ),
              ),
              title: Text(Translations.of(context).get("Live Order(s)"), style: AppTextStyles.bodyBold),
              children: List.generate(activeOrders.length, (i) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AddressIcon(
                        isRTL: isRTL,
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
                              Translations.of(context).get('Address'),
                              style: AppTextStyles.subtitleBold,
                            ),
                            Row(
                              children: [
                                Text(
                                  activeOrders[i].address.kind.title,
                                  style: AppTextStyles.subtitle,
                                ),
                                SizedBox(width: 5),
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
                      SizedBox(width: 5),
                      Expanded(
                        flex: 2,
                        child: AppButtons.primarySm(
                          onPressed: () => Navigator.of(context, rootNavigator: true).pushNamed(TrackOrderPage.routeName, arguments: activeOrders[i]),
                          child: Text(Translations.of(context).get("Track Order")),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
