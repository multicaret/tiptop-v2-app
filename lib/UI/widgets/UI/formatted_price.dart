import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FormattedPrice extends StatelessWidget {
  final String price;
  final bool isDiscounted;
  final bool isLarge;

  FormattedPrice({
    @required this.price,
    this.isDiscounted = false,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Transform.translate(
      //Todo: Find a better way to remove the extra padding
      offset: Offset(isLarge ? 0 : appProvider.isRTL ? 8 : -8, 0),
      child: Html(
        shrinkWrap: !isLarge,
        data: """$price""",
        style: {
          "html": Style(
            textAlign: isLarge ? TextAlign.center : TextAlign.start,
          ),
          "body": Style.fromTextStyle(
            AppTextStyles.dynamicValues(
              color: isDiscounted ? AppColors.text50 : AppColors.secondaryDark,
              height: isLarge ? 1 : 0.3,
              fontSize: isDiscounted
                  ? isLarge
                      ? 18
                      : 12
                  : isLarge
                      ? 20
                      : 14,
              fontWeight: FontWeight.w600,
              decoration: isDiscounted ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        },
      ),
    );
  }
}
