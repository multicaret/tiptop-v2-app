import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AppRatingBar extends StatelessWidget {
  final double initialRating;
  final Function onRatingUpdate;
  final bool hasLabel;
  final bool disabled;
  final double starSize;
  final double starsGutter;

  AppRatingBar({
    this.initialRating = 0,
    this.onRatingUpdate,
    this.hasLabel = false,
    this.disabled = false,
    this.starSize = 20,
    this.starsGutter = 10,
  });

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Row(
      children: <Widget>[
        RatingBar(
          ignoreGestures: disabled,
          glow: false,
          initialRating: initialRating,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: starSize,
          ratingWidget: RatingWidget(
            full: Image.asset(
              'assets/images/star-filled.png',
              width: starSize,
            ),
            half: Image.asset(
              'assets/images/star-half.png',
              width: starSize,
            ),
            empty: Image.asset(
              'assets/images/star-empty.png',
              width: starSize,
            ),
          ),
          itemPadding: EdgeInsets.symmetric(horizontal: starsGutter / 2),
          onRatingUpdate: onRatingUpdate,
        ),
        if (hasLabel) SizedBox(width: 5),
        if (hasLabel) Text('$initialRating', style: AppTextStyles.subtitle),
      ],
    );
  }
}
