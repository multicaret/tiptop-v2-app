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
  final Function submitAction;
  final String total;

  OrderButton({
    @required this.cartProvider,
    @required this.isRTL,
    this.submitAction,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cartProvider.noMarketCart
          ? null
          : () {
              if (submitAction != null) {
                submitAction();
              } else {
                Navigator.of(context, rootNavigator: true).pushNamed(CheckoutPage.routeName);
              }
            },
      child: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.only(top: 20, bottom: 40, left: screenHorizontalPadding, right: screenHorizontalPadding,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 45,
                child: Text(Translations.of(context).get(submitAction == null ? 'Continue' : 'Order Now')),
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
              height: 45,
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
