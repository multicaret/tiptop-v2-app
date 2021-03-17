import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';

class CartControls extends StatelessWidget {
  final Product product;
  final bool isZero;
  final Function editCartAction;

  CartControls({
    @required this.product,
    @required this.isZero,
    @required this.editCartAction,
  });

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    double cartButtonHeight = getCartControlButtonHeight(context);

    return Positioned(
      bottom: 0,
      left: cartControlsMargin,
      right: cartControlsMargin,
      height: cartButtonHeight,
      child: Stack(
        children: [
          //Remove button
          Positioned(
            left: cartButtonHeight,
            height: cartButtonHeight,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: cartButtonHeight,
              height: cartButtonHeight,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(isZero ? 10 : 0),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: AppColors.shadow
                  ),
                ]
              ),
              child: Center(child: Text('1')),
            ),
          ),
          buttonAnimatedContainer(
            context: context,
            actionName: 'remove',
            isRTL: appProvider.isRTL,
          ),
          //Add Button
          buttonAnimatedContainer(
            context: context,
            actionName: 'add',
            isRTL: appProvider.isRTL,
          ),
        ],
      ),
    );
  }

  double getLeftOffset(String actionName, bool isRTL, double cartButtonHeight) {
    if (actionName == 'add') {
      return isZero
          ? cartButtonHeight
          : isRTL
              ? 0
              : cartButtonHeight * 2;
    } else if (actionName == 'remove') {
      return isZero
          ? cartButtonHeight
          : isRTL
              ? cartButtonHeight * 2
              : 0;
    } else {
      return 0;
    }
  }

  BorderRadius getBorderRadius(String actionName, bool isRTL) {
    if (actionName == 'add') {
      return BorderRadius.only(
        topLeft: Radius.circular(isZero || isRTL ? 10 : 0),
        bottomLeft: Radius.circular(isZero || isRTL ? 10 : 0),
        topRight: Radius.circular(isZero || !isRTL ? 10 : 0),
        bottomRight: Radius.circular(isZero || !isRTL ? 10 : 0),
      );
    } else if (actionName == 'remove') {
      return BorderRadius.only(
        topLeft: Radius.circular(isZero || !isRTL ? 10 : 0),
        bottomLeft: Radius.circular(isZero || !isRTL ? 10 : 0),
        topRight: Radius.circular(isZero || isRTL ? 10 : 0),
        bottomRight: Radius.circular(isZero || isRTL ? 10 : 0),
      );
    } else {
      return BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
    }
  }

  Widget buttonAnimatedContainer({
    @required BuildContext context,
    @required String actionName,
    @required bool isRTL,
  }) {
    double cartButtonHeight = getCartControlButtonHeight(context);

    return AnimatedPositioned(
      duration: Duration(milliseconds: 200),
      left: getLeftOffset(actionName, isRTL, cartButtonHeight),
      child: InkWell(
        onTap: () {
          print('action: $actionName');
          editCartAction(actionName);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: cartButtonHeight,
          width: cartButtonHeight,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: getBorderRadius(actionName, isRTL),
            boxShadow: [
              BoxShadow(blurRadius: 6, color: AppColors.shadow),
            ],
          ),
          child: AppIcon.iconXsWhite(actionName == 'add' ? FontAwesomeIcons.plus : FontAwesomeIcons.minus),
        ),
      ),
    );
  }
}
