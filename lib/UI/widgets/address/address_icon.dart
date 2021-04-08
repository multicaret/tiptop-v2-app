import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AddressIcon extends StatelessWidget {
  final bool isRTL;
  final String icon;
  final bool isAsset;

  AddressIcon({@required this.isRTL, @required this.icon, this.isAsset = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isRTL
            ? const Border(
                left: BorderSide(color: AppColors.border),
              )
            : const Border(
                right: BorderSide(color: AppColors.border),
              ),
      ),
      padding: EdgeInsets.only(
        right: isRTL ? 0 : 10,
        left: isRTL ? 10 : 0,
      ),
      margin: EdgeInsets.only(
        right: isRTL ? 0 : 10,
        left: isRTL ? 10 : 0,
      ),
      child: isAsset
          ? Image(
              image: AssetImage(icon),
              width: 37,
            )
          : CachedNetworkImage(
              imageUrl: icon,
              width: 37,
              height: 37,
              placeholder: (_, __) => SpinKitFadingCircle(color: AppColors.secondary, size: 20),
            ),
    );
  }
}
