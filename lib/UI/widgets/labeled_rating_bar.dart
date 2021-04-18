import 'package:flutter/material.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import 'UI/input/app_rating_bar.dart';

class LabeledRatingBar extends StatelessWidget {
  final Function setRatingValue;

  LabeledRatingBar({@required this.setRatingValue});

  final List<String> _ratingStarsLabels = [
    "Very Bad",
    "Bad",
    "Okay",
    "Good",
    "Very Good",
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          AppRatingBar(
            starsGutter: fullWidthStarsGutter,
            starSize: (screenSize.width - (fullWidthStarsGutter * 5) - (screenHorizontalPadding * 2)) / 5,
            onRatingUpdate: (value) => setRatingValue(value),
          ),
          const SizedBox(height: 15),
          Row(
            children: List.generate(
              _ratingStarsLabels.length,
              (i) => Expanded(
                child: Text(
                  Translations.of(context).get(_ratingStarsLabels[i]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
