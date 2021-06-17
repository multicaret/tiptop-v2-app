import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ParentCategoriesTabs extends StatelessWidget {
  final int selectedParentCategoryId;
  final TabController tabController;
  final List<Widget> parentCategoriesTabs;

  const ParentCategoriesTabs({
    @required this.selectedParentCategoryId,
    @required this.tabController,
    @required this.parentCategoriesTabs,
  });

  static double _parentCategoriesTabHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: _parentCategoriesTabHeight,
      color: AppColors.primary,
      child: TabBar(
        indicatorPadding: const EdgeInsets.only(top: 6, left: 6, right: 6),
        isScrollable: true,
        controller: tabController,
        labelStyle: AppTextStyles.subtitle,
        unselectedLabelStyle: AppTextStyles.subtitleWhite,
        unselectedLabelColor: AppColors.white,
        labelColor: AppColors.primary,
        labelPadding: const EdgeInsets.symmetric(horizontal: 15),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          color: Colors.white,
        ),
        indicatorColor: AppColors.white,
        tabs: parentCategoriesTabs,
      ),
    );
  }
}
