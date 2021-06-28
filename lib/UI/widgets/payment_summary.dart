import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class PaymentSummary extends StatelessWidget {
  final List<PaymentSummaryTotal> totals;
  final bool translateTitle;

  PaymentSummary({this.totals, this.translateTitle = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(totals.length, (i) {
        return Consumer<AppProvider>(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translateTitle ? Translations.of(context).get(totals[i].title) : totals[i].title,
                style: totals[i].isGrandTotal
                    ? AppTextStyles.bodyBoldSecondaryDark
                    : totals[i].isSavedAmount
                        ? AppTextStyles.bodyBold.copyWith(color: Colors.green)
                        : AppTextStyles.body,
              ),
              Expanded(
                child: Html(
                  data: """${totals[i].value}""",
                  style: {
                    "body": Style(
                      textAlign: TextAlign.end,
                      color: totals[i].isGrandTotal
                          ? AppColors.secondary
                          : totals[i].isSavedAmount
                              ? Colors.green
                              : AppColors.primary,
                      fontWeight: totals[i].isGrandTotal || totals[i].isSavedAmount ? FontWeight.w600 : FontWeight.w400,
                      textDecoration: totals[i].isDiscounted ? TextDecoration.lineThrough : null,
                    ),
                  },
                ),
              ),
            ],
          ),
          builder: (c, appProvider, child) => Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: appProvider.isRTL ? screenHorizontalPadding : 7,
              left: appProvider.isRTL ? 7 : screenHorizontalPadding,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
              color: AppColors.white,
            ),
            child: child,
          ),
        );
      }),
    );
  }
}
