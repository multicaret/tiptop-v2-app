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

  AppRatingBar({
    this.initialRating = 0,
    this.onRatingUpdate,
    this.hasLabel = false,
    this.disabled = false,
    this.starSize = 20,
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
            full: Icon(FontAwesomeIcons.solidStar, color: AppColors.secondaryDark),
            half: Image.asset(
              'assets/images/star-half.png',
              fit: BoxFit.cover,
            ),
            empty: Icon(FontAwesomeIcons.star, color: AppColors.border),
          ),
          itemPadding: appProvider.dir == 'ltr' ? EdgeInsets.only(right: 5.0) : EdgeInsets.only(left: 5.0),
          onRatingUpdate: onRatingUpdate,
        ),
        if (hasLabel) SizedBox(width: 5),
        if (hasLabel) Text('$initialRating', style: AppTextStyles.subtitle),
      ],
    );
  }
}
