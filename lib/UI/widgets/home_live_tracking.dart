import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/track_order_page.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'address_icon.dart';

class HomeLiveTracking extends StatelessWidget {
  final bool isRTL;

  HomeLiveTracking({this.isRTL});

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
                  child: Text('1', style: AppTextStyles.subtitleBold),
                ),
              ),
              title: Text(Translations.of(context).get("Live Order"), style: AppTextStyles.bodyBold),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    /*borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                        ),*/
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AddressIcon(
                        isRTL: isRTL,
                        icon: 'assets/images/address-home-icon.png',
                      ),
                      Expanded(
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
                                  'Home',
                                  style: AppTextStyles.subtitle,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Sultan Selim Mah. Tuna Cad. Yasam Evleri Residence',
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: Size(120, 45)),
                        onPressed: () => Navigator.of(context, rootNavigator: true).pushNamed(TrackOrderPage.routeName),
                        child: Text(Translations.of(context).get("Track Order")),
                      ),
                    ],
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
