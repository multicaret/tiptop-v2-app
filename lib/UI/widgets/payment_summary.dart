import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class PaymentSummary extends StatelessWidget {
  final List<Map<String, String>> totals;
  final bool isRTL;

  PaymentSummary({this.totals, this.isRTL});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(totals.length, (i) {
        bool isLastItem = i == totals.length - 1;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            right: isRTL ? 17 : 7,
            left: isRTL ? 7 : 17,
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
            color: AppColors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Translations.of(context).get(totals[i]['title']),
                style: isLastItem ? AppTextStyles.bodyBoldSecondaryDark : AppTextStyles.body,
              ),
              Expanded(
                child: Html(
                  data: """${totals[i]['value']}""",
                  style: {
                    "body": Style(
                      textAlign: TextAlign.end,
                      color: isLastItem ? AppColors.secondaryDark : AppColors.primary,
                      fontWeight: isLastItem ? FontWeight.w600 : FontWeight.w400,
                    ),
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
