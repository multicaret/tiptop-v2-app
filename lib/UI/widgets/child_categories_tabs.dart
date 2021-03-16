import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ChildCategoriesTabs extends StatelessWidget {
  final List<Category> children;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final Function action;
  final int selectedChildCategoryId;

  ChildCategoriesTabs({
    @required this.children,
    @required this.itemScrollController,
    @required this.itemPositionsListener,
    @required this.action,
    @required this.selectedChildCategoryId,
  });

  static double childCategoriesTabsHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: childCategoriesTabsHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset.fromDirection(1.57, 5),
          )
        ],
      ),
      child: ScrollablePositionedList.builder(
        itemCount: children.length,
        itemBuilder: (context, i) => childTab(i),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget childTab(int i) {
    bool _isCurrentChildSelected = children[i].id == selectedChildCategoryId;

    return InkWell(
      onTap: () => action(i),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: _isCurrentChildSelected ? 10 : 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isCurrentChildSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          children[i].title,
          style: _isCurrentChildSelected ? AppTextStyles.subtitleWhite : AppTextStyles.subtitle,
        ),
      ),
    );
  }

/*
  Widget childTab(int i) {
    bool _isCurrentChildSelected = children[i].id == _selectedChildCategoryId;

    return InkWell(
      onTap: _isCurrentChildSelected
          ? null
          : () {
              setState(() {
                _selectedChildCategoryId = widget.children[i].id;
              });
              scrollTo(i);
            },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: _isCurrentChildSelected ? 10 : 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isCurrentChildSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.children[i].title,
          style: _isCurrentChildSelected ? AppTextStyles.subtitleWhite : AppTextStyles.subtitle,
        ),
      ),
    );
  }
*/
}
