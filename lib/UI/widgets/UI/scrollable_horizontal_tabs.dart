import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/widgets/UI/scrollable_horizontal_tab_child.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: scrollableHorizontalTabBarHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5, color: AppColors.border)),
        color: isInverted ? AppColors.primary : AppColors.white,
      ),
      child: ListView.builder(
        controller: itemScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        itemBuilder: (c, i) => ScrollableHorizontalTabChild(
          index: i,
          isSelected: children[i].id == selectedChildCategoryId,
          isInverted: isInverted,
          action: action,
          childCategory: children[i],
          scrollController: itemScrollController,
        ),
      ),
    );
  }
}
