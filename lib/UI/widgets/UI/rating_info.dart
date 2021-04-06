import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class RatingInfo extends StatelessWidget {
  final bool hasWhiteBg;
  final double ratingValue;
  final int ratingsCount;

  RatingInfo({
    this.hasWhiteBg = false,
    @required this.ratingValue,
    @required this.ratingsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppIcons.iconXsSecondary(FontAwesomeIcons.solidStar),
        const SizedBox(width: 4),
        Text('$ratingValue', style: AppTextStyles.subtitleSecondary),
        const SizedBox(width: 4),
        Text(
          '($ratingsCount+)',
          style: hasWhiteBg ? AppTextStyles.subtitle50 : AppTextStyles.subtitleWhite50,
        )
      ],
    );
  }
}
