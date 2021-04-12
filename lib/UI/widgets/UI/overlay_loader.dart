import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import 'app_loader.dart';

class OverlayLoader extends StatelessWidget {
  final double height;

  OverlayLoader({this.height});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        height: height,
        color: AppColors.primary.withOpacity(0.8),
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.white.withOpacity(0.9),
            ),
            child: const AppLoader(),
          ),
        ),
      ),
    );
  }
}
