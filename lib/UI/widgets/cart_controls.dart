import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CartControls extends StatelessWidget {
  final Product product;
  final double cartButtonHeight;
  final bool isModalControls;
  final int quantity;
  final Function editCartAction;
  final bool disableAddition;

  CartControls({
    @required this.product,
    @required this.cartButtonHeight,
    this.isModalControls = false,
    @required this.quantity,
    @required this.editCartAction,
    @required this.disableAddition,
  });

  static double productUnitTitleHeight = 12;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    Size screenSize = MediaQuery.of(context).size;
    double screenThirdWidth = (screenSize.width - (17 * 2)) / 3;

    return Stack(
      children: [
        //Quantity
        Positioned(
          left: isModalControls ? screenThirdWidth : cartButtonHeight,
          height: cartButtonHeight,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: isModalControls ? screenThirdWidth : cartButtonHeight,
            height: cartButtonHeight,
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(quantity == 0 ? 10 : 0), boxShadow: [
              BoxShadow(blurRadius: 6, color: AppColors.shadow),
            ]),
            child: Center(
              child: Text(
                quantity == 0 ? '' : '$quantity',
                style: quantity.toString().length >= 2 ? AppTextStyles.subtitleXsBold : AppTextStyles.subtitleBold,
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ),
        //Remove Button
        buttonAnimatedContainer(
          context: context,
          action: CartAction.REMOVE,
          isRTL: appProvider.isRTL,
          screenThirdWidth: screenThirdWidth,
        ),
        //Add Button
        buttonAnimatedContainer(
          context: context,
          action: CartAction.ADD,
          isRTL: appProvider.isRTL,
          screenThirdWidth: screenThirdWidth,
        ),
        if (isModalControls && quantity == 0)
          Positioned.fill(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: quantity == 0 ? 1 : 0,
              child: ElevatedButton(
                onPressed: () => editCartAction(CartAction.ADD),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon.iconWhite(LineAwesomeIcons.shopping_cart),
                    SizedBox(width: 5),
                    Text(
                      'Add to Cart',
                      style: AppTextStyles.button,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  double getLeftOffset(CartAction action, bool isRTL, double cartButtonHeight) {
    if (action == CartAction.ADD) {
      return quantity == 0
          ? cartButtonHeight
          : isRTL
              ? 0
              : cartButtonHeight * 2;
    } else if (action == CartAction.REMOVE) {
      return quantity == 0
          ? cartButtonHeight
          : isRTL
              ? cartButtonHeight * 2
              : 0;
    } else {
      return 0;
    }
  }

  BorderRadius getBorderRadius(CartAction action, bool isRTL) {
    if (action == CartAction.ADD) {
      return BorderRadius.only(
        topLeft: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
        bottomLeft: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
        topRight: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
        bottomRight: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
      );
    } else if (action == CartAction.REMOVE) {
      return BorderRadius.only(
        topLeft: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
        bottomLeft: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
        topRight: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
        bottomRight: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
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

  double getModalLeftOffset(double screenThirdWidth, CartAction action, bool isRTL) {
    if (action == CartAction.ADD) {
      return isRTL ? 0 : screenThirdWidth * 2;
    } else {
      return isRTL ? screenThirdWidth * 2 : 0;
    }
  }

  Widget buttonAnimatedContainer({
    @required BuildContext context,
    @required CartAction action,
    @required bool isRTL,
    @required double screenThirdWidth,
  }) {
    bool _disableAddition = action == CartAction.ADD && disableAddition;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 200),
      left: isModalControls ? getModalLeftOffset(screenThirdWidth, action, isRTL) : getLeftOffset(action, isRTL, cartButtonHeight),
      child: InkWell(
        onTap: _disableAddition
            ? null
            : () {
                editCartAction(action);
              },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: cartButtonHeight,
          width: isModalControls ? screenThirdWidth : cartButtonHeight,
          decoration: BoxDecoration(
            color: _disableAddition ? AppColors.disabled : AppColors.primary,
            borderRadius: getBorderRadius(action, isRTL),
            boxShadow: [
              BoxShadow(blurRadius: 6, color: AppColors.shadow),
            ],
          ),
          child: _disableAddition
              ? AppIcon.iconXsWhite50(FontAwesomeIcons.plus)
              : AppIcon.iconXsWhite(
                  action == CartAction.ADD
                      ? FontAwesomeIcons.plus
                      : quantity == 1
                          ? FontAwesomeIcons.trashAlt
                          : FontAwesomeIcons.minus,
                ),
        ),
      ),
    );
  }
}
