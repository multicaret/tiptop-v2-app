import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/profile/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/address/address_icon.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/food_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FoodAddressSelectButton extends StatelessWidget {
  final bool isDisabled;
  final bool hasETA;
  final String addressKindIcon;
  final String addressKindTitle;
  final String addressText;
  final bool forceAddressView;

  FoodAddressSelectButton({
    this.isDisabled = false,
    this.hasETA = true,
    this.addressKindIcon,
    this.addressKindTitle,
    this.addressText,
    this.forceAddressView = false,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Consumer3<AppProvider, FoodProvider, AddressesProvider>(
      builder: (c, appProvider, foodProvider, addressesProvider, _) {
        bool tempShowSelectAddress = !addressesProvider.addressIsSelected || addressesProvider.selectedAddress == null || !appProvider.isAuth;
        bool showSelectAddress = tempShowSelectAddress;
        showSelectAddress = foodProvider.foodHomeDataRequestError || tempShowSelectAddress;
        EstimatedArrivalTime estimatedArrivalTime = foodProvider.foodHomeData != null ? foodProvider.foodHomeData.estimatedArrivalTime : null;
        bool etaIsVisible = estimatedArrivalTime != null && forceAddressView || showSelectAddress || !hasETA;

        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 2, color: AppColors.primary),
            ),
          ),
          height: 70,
          child: Stack(
            children: [
              if (!showSelectAddress && hasETA && estimatedArrivalTime != null)
                Positioned.fill(
                  child: Container(
                    width: screenSize.width * 0.2,
                    color: AppColors.primary,
                    alignment: !appProvider.isRTL ? Alignment.centerRight : Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      right: !appProvider.isRTL ? screenHorizontalPadding : 0,
                      left: !appProvider.isRTL ? 0 : screenHorizontalPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ETA',
                          style: AppTextStyles.subtitleWhite,
                        ),
                        const SizedBox(height: 5),
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
                left: !appProvider.isRTL ? 0 : null,
                right: !appProvider.isRTL ? null : 0,
                child: AnimatedContainer(
                  padding: EdgeInsets.only(
                    left: !appProvider.isRTL ? screenHorizontalPadding : 0,
                    right: !appProvider.isRTL ? 0 : screenHorizontalPadding,
                    top: 10,
                    bottom: 10,
                  ),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  color: AppColors.white,
                  height: 70,
                  width: foodProvider.isLoadingFoodHomeData || etaIsVisible ? screenSize.width : screenSize.width * 0.75,
                  child: InkWell(
                    onTap: isDisabled
                        ? null
                        : () {
                            if (appProvider.isAuth) {
                              pushCupertinoPage(
                                context,
                                AddressesPage(currentChannel: AppChannel.FOOD),
                                rootNavigator: true,
                              );
                            } else {
                              showToast(msg: Translations.of(context).get("You Need to Log In First!"));
                              Navigator.of(context, rootNavigator: true).pushNamed(
                                WalkthroughPage.routeName,
                                arguments: {
                                  'should_pop_only': true,
                                },
                              );
                            }
                          },
                    child: foodProvider.isLoadingFoodHomeData || (showSelectAddress && !forceAddressView)
                        ? Container(
                            child: Text(
                              Translations.of(context).get("Select Address"),
                              style: AppTextStyles.bodyBold,
                            ),
                            alignment: !appProvider.isRTL ? Alignment.centerLeft : Alignment.centerRight,
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AddressIcon(
                                icon: addressKindIcon ?? addressesProvider.selectedAddress.kind.icon,
                                isAsset: false,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      Translations.of(context).get("Address"),
                                      style: AppTextStyles.subtitleBold,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          addressKindTitle ?? addressesProvider.selectedAddress.kind.title,
                                          style: AppTextStyles.subtitle,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            addressText ?? addressesProvider.selectedAddress.address1,
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
                              if (!isDisabled)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: AppIcons.icon(!appProvider.isRTL ? FontAwesomeIcons.angleRight : FontAwesomeIcons.angleLeft),
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
    );
  }
}
