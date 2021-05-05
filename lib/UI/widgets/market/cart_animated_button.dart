import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

class CartAnimatedButton extends StatelessWidget {
  final bool isRTL;
  final Function onTap;
  final bool isProductDisabled;
  final CartAction cartAction;
  final int quantity;
  final bool isModalControls;
  final bool isLoadingFirstAddition;

  const CartAnimatedButton({
    @required this.isRTL,
    this.onTap,
    this.isProductDisabled = false,
    @required this.cartAction,
    @required this.quantity,
    this.isModalControls = false,
    this.isLoadingFirstAddition = false,
  });

  double getLeftOffset(CartAction cartAction, bool isRTL, double cartButtonHeight, int quantity) {
    if (cartAction == CartAction.ADD) {
      return quantity == 0
          ? cartButtonHeight
          : isRTL
              ? 0
              : cartButtonHeight * 2;
    } else if (cartAction == CartAction.REMOVE) {
      return quantity == 0
          ? cartButtonHeight
          : isRTL
              ? cartButtonHeight * 2
              : 0;
    } else {
      return 0;
    }
  }

  BorderRadius getBorderRadius(CartAction cartAction, bool isRTL, int quantity) {
    if (cartAction == CartAction.ADD) {
      return BorderRadius.only(
        topLeft: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
        bottomLeft: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
        topRight: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
        bottomRight: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
      );
    } else if (cartAction == CartAction.REMOVE) {
      return BorderRadius.only(
        topLeft: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
        bottomLeft: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
        topRight: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
        bottomRight: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
      );
    } else {
      return const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
    }
  }

  double getModalLeftOffset(double screenThirdWidth, CartAction cartAction, bool isRTL) {
    if (cartAction == CartAction.ADD) {
      return isRTL ? 0 : screenThirdWidth * 2;
    } else {
      return isRTL ? screenThirdWidth * 2 : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenThirdWidth = (screenSize.width - (screenHorizontalPadding * 2)) / 3;
    double cartButtonHeight = isModalControls ? buttonHeightSm : getCartControlButtonHeight(context);
    bool disabled = onTap == null || isProductDisabled;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      left: isModalControls ? getModalLeftOffset(screenThirdWidth, cartAction, isRTL) : getLeftOffset(cartAction, isRTL, cartButtonHeight, quantity),
      child: InkWell(
        onTap: disabled ? () => showToast(msg: Translations.of(context).get("This item is not available")) : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: cartButtonHeight,
          width: isModalControls ? screenThirdWidth : cartButtonHeight,
          decoration: BoxDecoration(
            color: disabled ? AppColors.primaryLight : AppColors.primary,
            borderRadius: getBorderRadius(cartAction, isRTL, quantity),
            boxShadow: [
              const BoxShadow(blurRadius: 6, color: AppColors.shadow),
            ],
          ),
          child: !isModalControls && isLoadingFirstAddition
              ? SpinKitFadingCircle(
                  color: AppColors.white,
                  size: cartButtonHeight * 0.6,
                )
              : Icon(
                  cartAction == CartAction.ADD
                      ? FontAwesomeIcons.plus
                      : quantity == 1
                          ? FontAwesomeIcons.trashAlt
                          : FontAwesomeIcons.minus,
                  size: 14,
                  color: AppColors.white.withOpacity(disabled ? 0.6 : 1),
                ),
        ),
      ),
    );
  }
}
