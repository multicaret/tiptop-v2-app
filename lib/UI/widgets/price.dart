import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class Price extends StatelessWidget {
  final String price;
  final bool isDiscounted;

  Price({
    @required this.price,
    this.isDiscounted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      //Todo: Find a better way to remove the extra padding
      offset: Offset(-8, 0),
      child: Html(
        shrinkWrap: true,
        data: """$price""",
        style: {
          "body": Style.fromTextStyle(
            AppTextStyles.dynamicValues(
              color: isDiscounted ? AppColors.text50 : AppColors.secondaryDark,
              height: 0.3,
              fontSize: isDiscounted ? 12 : 14,
              fontWeight: FontWeight.w600,
              decoration: isDiscounted ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        },
      ),
    );
  }
}
