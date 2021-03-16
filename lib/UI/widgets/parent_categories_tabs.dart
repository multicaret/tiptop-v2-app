import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ParentCategoriesTabs extends StatelessWidget {
  final List<Category> parents;
  final int selectedParentCategoryId;
  final TabController tabController;
  final int currentTabIndex;

  const ParentCategoriesTabs({
    @required this.parents,
    @required this.selectedParentCategoryId,
    @required this.tabController,
    @required this.currentTabIndex,
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
        isScrollable: true,
        controller: tabController,
        indicator: UnderlineTabIndicator(
          // borderSide: BorderSide(width: 42, color: AppColors.white),
          borderSide: BorderSide(width: 0),
        ),
        indicatorColor: AppColors.white,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: <Widget>[
          ...parents.asMap().entries.map((entry) {
            int index = entry.key;
            Category parent = entry.value;

            return Tab(
              child: Transform.translate(
                offset: Offset(0.0, _parentsTabHeight - _selectedParentTabHeight),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: currentTabIndex == index ? 15 : 0),
                  margin: EdgeInsets.only(top: currentTabIndex == index ? _parentsTabHeight - _selectedParentTabHeight : 0),
                  decoration: BoxDecoration(
                    color: currentTabIndex == index ? AppColors.white : AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    parent.title,
                    style: currentTabIndex == index ? AppTextStyles.subtitle : AppTextStyles.subtitleWhite,
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
