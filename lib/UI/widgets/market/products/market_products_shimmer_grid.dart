import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

class MarketProductsShimmerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double productGridItemWidth = getColItemHeight(3, context);
    double productGridItemHeight = getColItemHeight(3, context) + 70;
    double productGridItemAspectRatio = productGridItemWidth / productGridItemHeight;

    return Container(
      color: AppColors.white,
      child: Shimmer.fromColors(
        baseColor: AppColors.bg,
        highlightColor: AppColors.white,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: GridView.count(
            // physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            childAspectRatio: productGridItemAspectRatio,
            padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: listItemVerticalPadding),
            children: List.generate(
              3 * 5,
              (i) => Container(
                height: getColItemHeight(3, context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: getColItemHeight(3, context),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 15,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 10,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
