import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_cahched_network_image.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AddressIcon extends StatelessWidget {
  final String icon;
  final bool isAsset;

  AddressIcon({@required this.icon, this.isAsset = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      child: isAsset
          ? Image(
              image: AssetImage(icon),
              width: addressIconSize,
            )
          : AppCachedNetworkImage(
              imageUrl: icon,
              width: addressIconSize,
            ),
      builder: (c, appProvider, child) => Container(
        decoration: BoxDecoration(
          border: appProvider.isRTL
              ? const Border(
                  left: BorderSide(color: AppColors.border),
                )
              : const Border(
                  right: BorderSide(color: AppColors.border),
                ),
        ),
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
    );
  }
}
