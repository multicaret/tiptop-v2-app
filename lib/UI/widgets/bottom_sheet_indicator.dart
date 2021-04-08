import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class BottomSheetIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: 56,
      height: 3,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(2.0),
      ),
    );
  }
}
