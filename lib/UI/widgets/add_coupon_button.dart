import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/text_field_dialog.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';

import 'UI/dialogs/confirm_alert_dialog.dart';

class AddCouponButton extends StatefulWidget {
  @override
  _AddCouponButtonState createState() => _AddCouponButtonState();
}

class _AddCouponButtonState extends State<AddCouponButton> {
  String couponValue;
  bool isCouponSubmitted = false;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Material(
      color: AppColors.white,
      child: InkWell(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: !isCouponSubmitted
              ? Row(
                  children: [
                    Container(
                      width: 36,
                      height: 30,
                      child: AppIcon.iconXsSecondary(FontAwesomeIcons.plus),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 5)],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(Translations.of(context).get('Add Coupon')),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(couponValue),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmAlertDialog(
                            title: 'Are you sure you want to delete the coupon?',
                          ),
                        ).then((response) => {
                              if (response != null && response)
                                setState(() {
                                  isCouponSubmitted = false;
                                }),
                            });
                      },
                      child: Container(
                        width: 36,
                        height: 30,
                        child: AppIcon.iconXsSecondary(FontAwesomeIcons.trash),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 5)],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    )
                  ],
                ),
        ),
        onTap: !isCouponSubmitted
            ? () {
                showDialog(
                  context: context,
                  builder: (context) => TextFieldDialog(
                    textFieldHint: 'Enter Promo Code',
                  ),
                ).then((response) => {
                      if (response is String && response.isNotEmpty)
                        {
                          setState(() {
                            couponValue = response;
                            isCouponSubmitted = true;
                          }),
                        }
                    });
              }
            : null,
      ),
    );
  }
}
