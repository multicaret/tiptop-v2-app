import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ChildCategoriesTabs extends StatefulWidget {
  final List<Category> children;

  ChildCategoriesTabs({@required this.children});

  @override
  _ChildCategoriesTabsState createState() => _ChildCategoriesTabsState();
}

class _ChildCategoriesTabsState extends State<ChildCategoriesTabs> {
  static double childCategoriesTabsHeight = 50.0;
  int _selectedChildCategoryId;

  ItemScrollController itemScrollController;
  ItemPositionsListener itemPositionsListener;

  @override
  void initState() {
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
    _selectedChildCategoryId = widget.children[0].id;
    super.initState();
  }

  void scrollTo(int index) {
    itemScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      alignment: 0.05,
    );
  }

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
        itemCount: widget.children.length,
        itemBuilder: (context, i) => childTab(i),
        // initialScrollIndex: widget.children.indexWhere((parent) => parent.id == widget.selectedParentCategoryId),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget childTab(int i) {
    bool _isCurrentChildSelected = widget.children[i].id == _selectedChildCategoryId;

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
}
