import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AddressSelectButton extends StatelessWidget {
  final EstimatedArrivalTime estimatedArrivalTime;
  final bool isLoadingHomeData;

  AddressSelectButton({
    this.estimatedArrivalTime,
    this.isLoadingHomeData,
  });

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    String appDir = appProvider.dir;
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: AppColors.primary),
        ),
      ),
      height: 70,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              width: screenSize.width * 0.2,
              color: AppColors.primary,
              alignment: appDir == 'ltr' ? Alignment.centerRight : Alignment.centerLeft,
              padding: EdgeInsets.only(
                right: appDir == 'ltr' ? 17 : 0,
                left: appDir == 'ltr' ? 0 : 17,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ETA',
                    style: AppTextStyles.subtitleWhite,
                  ),
                  SizedBox(height: 5),
                  if (!isLoadingHomeData)
                    RichText(
                      overflow: TextOverflow.visible,
                      text: TextSpan(
                        style: AppTextStyles.bodyWhiteBold,
                        children: [
                          TextSpan(
                            text: estimatedArrivalTime.value,
                          ),
                          TextSpan(
                            text: estimatedArrivalTime.unit,
                            style: AppTextStyles.subtitleXsWhiteBold,
                          )
                        ],
                      ),
                      maxLines: 1,
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            left: appDir == 'ltr' ? 0 : null,
            right: appDir == 'ltr' ? null : 0,
            child: InkWell(
              onTap: () {
                //Todo: Open Addresses modal/bottom sheet
              },
              child: AnimatedContainer(
                padding: EdgeInsets.only(
                  left: appDir == 'ltr' ? 17 : 0,
                  right: appDir == 'ltr' ? 0 : 17,
                  top: 10,
                  bottom: 10,
                ),
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                color: AppColors.white,
                height: 70,
                width: isLoadingHomeData ? screenSize.width : screenSize.width * 0.75,
                child: isLoadingHomeData
                    ? Container(
                        child: Text(
                          Translations.of(context).get('Select Address'),
                          style: AppTextStyles.bodyBold,
                        ),
                        alignment: appDir == 'ltr' ? Alignment.centerLeft : Alignment.centerRight,
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              right: appDir == 'ltr' ? 10 : 0,
                              left: appDir == 'ltr' ? 0 : 10,
                            ),
                            margin: EdgeInsets.only(
                              right: appDir == 'ltr' ? 10 : 0,
                              left: appDir == 'ltr' ? 0 : 10,
                            ),
                            child: Image(
                              image: AssetImage('assets/images/address-home-icon.png'),
                              width: 37,
                            ),
                            decoration: BoxDecoration(
                              border: appDir == 'ltr'
                                  ? Border(
                                      right: BorderSide(
                                        width: 1,
                                        color: AppColors.border,
                                      ),
                                    )
                                  : Border(
                                      left: BorderSide(
                                      width: 1,
                                      color: AppColors.border,
                                    )),
                            ),
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
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: AppIcon.icon(appDir == 'ltr' ? FontAwesomeIcons.angleRight : FontAwesomeIcons.angleLeft),
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
