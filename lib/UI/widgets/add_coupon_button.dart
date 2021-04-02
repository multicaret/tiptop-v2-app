import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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
  TextEditingController textFieldController = TextEditingController();
  bool isCouponSubmitted = false;

  @override
  Widget build(BuildContext context) {

    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Material(
      color: AppColors.white,
      child: InkWell(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 17,
            bottom: 17,
            right: appProvider.isRTL ? 17 : 12,
            left: appProvider.isRTL ? 12 : 17,
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: !isCouponSubmitted
              ? InkWell(
                  child: Row(
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
                  ),
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
                  builder: (context) => ConfirmAlertDialog(
                    hasTextField: true,
                    textFieldHint: 'Enter Promo Code',
                    textFieldController: textFieldController,
                  ),
                ).then((response) => {
                      if (response != null && response)
                        setState(() {
                          couponValue = textFieldController.text.toString();
                          isCouponSubmitted = true;
                          textFieldController.clear();
                        }),
                    });
              }
            : null,
      ),
    );
  }
}
