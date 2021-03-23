import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AddressIcon extends StatelessWidget {
  final bool isRTL;
  final String icon;

  AddressIcon({@required this.isRTL, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return             Container(
      decoration: BoxDecoration(
        border: isRTL ? Border(left: BorderSide(color: AppColors.border)) : Border(right: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.only(
        right: isRTL ? 0 : 10,
        left: isRTL ? 10 : 0,
      ),
      margin: EdgeInsets.only(
        right: isRTL ? 0 : 10,
        left: isRTL ? 10 : 0,
      ),
      child: Image(
        image: AssetImage(icon),
        width: 37,
      ),
    );
  }
}
