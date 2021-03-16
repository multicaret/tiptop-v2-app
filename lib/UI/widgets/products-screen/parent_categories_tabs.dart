import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ParentCategoriesTabs extends StatelessWidget {
  final List<Category> parents;
  final int selectedParentCategoryId;
  final TabController tabController;

  const ParentCategoriesTabs({
    @required this.parents,
    @required this.selectedParentCategoryId,
    @required this.tabController,
  });

  static double _parentsTabHeight = 50.0;
  static double _selectedParentTabHeight = 46.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: _parentsTabHeight,
      color: AppColors.primary,
      child: TabBar(
        indicatorPadding: EdgeInsets.only(top: 6, left: 6, right: 6),
        isScrollable: true,
        controller: tabController,
        labelStyle: AppTextStyles.subtitle,
        unselectedLabelStyle: AppTextStyles.subtitleWhite,
        unselectedLabelColor: AppColors.white,
        labelColor: AppColors.primary,
        labelPadding: EdgeInsets.symmetric(horizontal: 15),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          color: Colors.white,
        ),
        indicatorColor: AppColors.white,
        tabs: <Widget>[
          ...parents.map((parent) => Transform.translate(
                offset: Offset(0.0, 3.0),
                child: Tab(text: parent.title),
              ))
        ],
      ),
    );
  }
}
