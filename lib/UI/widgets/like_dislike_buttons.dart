import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class LikeDislikeButtons extends StatelessWidget {
  final bool value;
  final Function setValue;

  LikeDislikeButtons({
    @required this.value,
    @required this.setValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setValue(true),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: value != null && value ? AppColors.secondary : AppColors.border),
            ),
            child: Icon(
              FontAwesomeIcons.thumbsUp,
              size: 20,
              color: value != null && value ? AppColors.secondary : AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => setValue(false),
          child: Transform.rotate(
            angle: math.pi,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: value != null && !value ? AppColors.secondary : AppColors.border),
              ),
              child: Icon(
                FontAwesomeIcons.thumbsUp,
                size: 20,
                color: value != null && !value ? AppColors.secondary : AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
