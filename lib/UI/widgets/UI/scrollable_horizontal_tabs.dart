import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ScrollableHorizontalTabs extends StatelessWidget {
  final List<Category> children;
  final AutoScrollController itemScrollController;
  final Function action;
  final int selectedChildCategoryId;
  final bool isInverted;

  ScrollableHorizontalTabs({
    @required this.children,
    @required this.itemScrollController,
    @required this.action,
    @required this.selectedChildCategoryId,
    this.isInverted = false,
  });

  static double tabsHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: tabsHeight,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5, color: AppColors.border)),
        color: isInverted ? AppColors.primary : AppColors.white,
      ),
      child: ListView(
        controller: itemScrollController,
        scrollDirection: Axis.horizontal,
        children: List.generate(children.length, (index) => childTab(index)),
      ),
    );
  }

  Widget childTab(int i) {
    bool _isCurrentChildSelected = children[i].id == selectedChildCategoryId;

    return AutoScrollTag(
      controller: itemScrollController,
      index: i,
      key: ValueKey(i),
      child: InkWell(
        onTap: () => action(i),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: _isCurrentChildSelected ? 10 : 0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isInverted
                ? _isCurrentChildSelected
                    ? AppColors.white
                    : AppColors.primary
                : _isCurrentChildSelected
                    ? AppColors.primary
                    : AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            children[i].title,
            style: isInverted
                ? _isCurrentChildSelected
                    ? AppTextStyles.subtitle
                    : AppTextStyles.subtitleWhite
                : _isCurrentChildSelected
                    ? AppTextStyles.subtitleWhite
                    : AppTextStyles.subtitle,
          ),
        ),
      ),
    );
  }
}
