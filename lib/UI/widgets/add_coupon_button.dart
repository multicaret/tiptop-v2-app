import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class AddCouponButton extends StatelessWidget {
  final String couponCode;
  final Function deleteAction;
  final Function enterCouponAction;

  AddCouponButton({
    @required this.couponCode,
    @required this.deleteAction,
    @required this.enterCouponAction,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: couponCode == null
              ? Row(
                  children: [
                    Container(
                      width: 36,
                      height: 30,
                      child: AppIcons.iconXsSecondary(FontAwesomeIcons.plus),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [const BoxShadow(color: AppColors.shadow, blurRadius: 5)],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(Translations.of(context).get('Add Coupon')),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(couponCode),
                    InkWell(
                      onTap: deleteAction,
                      child: Container(
                        width: 36,
                        height: 30,
                        child: AppIcons.iconXsSecondary(FontAwesomeIcons.trash),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [const BoxShadow(color: AppColors.shadow, blurRadius: 5)],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    )
                  ],
                ),
        ),
        onTap: couponCode == null ? enterCouponAction : null,
      ),
    );
  }
}
