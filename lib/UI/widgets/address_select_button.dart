import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/address_icon.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AddressSelectButton extends StatelessWidget {
  final bool isLoadingHomeData;
  final bool isDisabled;
  final bool hasETA;
  final String addressKindIcon;
  final String addressKindTitle;
  final String addressText;
  final bool forceAddressView;

  AddressSelectButton({
    this.isLoadingHomeData = false,
    this.isDisabled = false,
    this.hasETA = true,
    this.addressKindIcon,
    this.addressKindTitle,
    this.addressText,
    this.forceAddressView = false,
  });

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    String appDir = appProvider.dir;
    Size screenSize = MediaQuery.of(context).size;

    return Consumer2<HomeProvider, AddressesProvider>(
      builder: (c, homeProvider, addressesProvider, _) {
        bool showSelectAddress = isLoadingHomeData ||
            homeProvider.noBranchFound ||
            homeProvider.homeDataRequestError ||
            homeProvider.estimatedArrivalTime == null ||
            !addressesProvider.addressIsSelected ||
            addressesProvider.selectedAddress == null ||
            !appProvider.isAuth;

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
                      if (!showSelectAddress && hasETA)
                        RichText(
                          overflow: TextOverflow.visible,
                          text: TextSpan(
                            style: AppTextStyles.bodyWhiteBold,
                            children: [
                              TextSpan(
                                text: homeProvider.estimatedArrivalTime.value,
                              ),
                              TextSpan(
                                text: homeProvider.estimatedArrivalTime.unit,
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
                  width: forceAddressView && (showSelectAddress || !hasETA) ? screenSize.width : screenSize.width * 0.75,
                  child: InkWell(
                    onTap: isDisabled
                        ? null
                        : () {
                            if (appProvider.isAuth) {
                              Navigator.of(context, rootNavigator: true).pushNamed(AddressesPage.routeName);
                            } else {
                              showToast(msg: 'You need to log in first!');
                              Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
                            }
                          },
                    child: showSelectAddress && !forceAddressView
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
                              AddressIcon(
                                isRTL: appProvider.isRTL,
                                icon: addressKindIcon ?? addressesProvider.selectedAddress.kind.icon,
                                isAsset: false,
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
                                          addressKindTitle ?? addressesProvider.selectedAddress.kind.title,
                                          style: AppTextStyles.subtitle,
                                        ),
                                        SizedBox(width: 5),
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
      },
    );
  }
}
