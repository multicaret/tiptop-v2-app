import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/triangle_painter.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class DiscountBadge extends StatelessWidget {
  final String value;

  DiscountBadge({
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: AppColors.primary,
          ),
          child: Center(
            child: Text(
              value,
              style: AppTextStyles.subtitleXxsSecondary,
            ),
          ),
        ),
        CustomPaint(
          size: Size(28.0, 5.0),
          painter: TrianglePainter(isDown: true, color: AppColors.primary),
        ),
      ],
    );
  }
}
