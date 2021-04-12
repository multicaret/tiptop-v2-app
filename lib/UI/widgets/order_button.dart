import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tiptop_v2/UI/pages/checkout_page.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class OrderButton extends StatelessWidget {
  final CartProvider cartProvider;
  final bool isRTL;
  final Function onTap;
  final String total;
  final String buttonText;

  OrderButton({
    @required this.cartProvider,
    @required this.isRTL,
    this.onTap,
    this.total,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.only(
          top: listItemVerticalPadding,
          bottom: actionButtonBottomPadding,
          left: screenHorizontalPadding,
          right: screenHorizontalPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: buttonHeightSm,
                child: Text(Translations.of(context).get(buttonText)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isRTL ? 0 : 8),
                    bottomLeft: Radius.circular(isRTL ? 0 : 8),
                    topRight: Radius.circular(isRTL ? 8 : 0),
                    bottomRight: Radius.circular(isRTL ? 8 : 0),
                  ),
                  boxShadow: [
                    const BoxShadow(color: AppColors.shadowDark, blurRadius: 6),
                  ],
                ),
              ),
            ),
            Container(
              height: buttonHeightSm,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(isRTL ? 0 : 8),
                  bottomRight: Radius.circular(isRTL ? 0 : 8),
                  topLeft: Radius.circular(isRTL ? 8 : 0),
                  bottomLeft: Radius.circular(isRTL ? 8 : 0),
                ),
                boxShadow: [
                  const BoxShadow(color: AppColors.shadowDark, blurRadius: 6),
                ],
              ),
              child: cartProvider.isLoadingAdjustCartQuantityRequest
                  ? SpinKitThreeBounce(
                      color: AppColors.primary,
                      size: 20,
                    )
                  : Text(
                      total,
                      style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w400),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
