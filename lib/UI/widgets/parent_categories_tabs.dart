import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ParentCategoriesTabs extends StatefulWidget {
  final List<Category> parents;
  final int selectedCategoryId;
  final int localSelectedCategoryId;
  final Function action;

  ParentCategoriesTabs({
    @required this.parents,
    @required this.selectedCategoryId,
    @required this.localSelectedCategoryId,
    @required this.action,
  });

  @override
  _ParentCategoriesTabsState createState() => _ParentCategoriesTabsState();
}

class _ParentCategoriesTabsState extends State<ParentCategoriesTabs> {
  static double parentTabsHeight = 50.0;

  ItemScrollController itemScrollController;
  ItemPositionsListener itemPositionsListener;

  @override
  void initState() {
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
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
      height: parentTabsHeight,
      color: AppColors.primary,
      child: ScrollablePositionedList.builder(
        itemCount: widget.parents.length,
        itemBuilder: (context, i) => parentTab(i),
        initialScrollIndex: widget.parents.indexWhere((parent) => parent.id == widget.selectedCategoryId),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget parentTab(int i) {
    bool _isCurrentParentSelected = widget.parents[i].id == widget.localSelectedCategoryId;

    return InkWell(
      onTap: _isCurrentParentSelected
          ? null
          : () {
              widget.action(widget.parents[i].id);
              scrollTo(i);
            },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: AppColors.primary,
        alignment: _isCurrentParentSelected ? Alignment.bottomCenter : Alignment.center,
        child: Container(
          alignment: Alignment.center,
          height: parentTabsHeight - 6,
          padding: EdgeInsets.symmetric(horizontal: _isCurrentParentSelected ? 10 : 0),
          decoration: BoxDecoration(
            color: _isCurrentParentSelected ? AppColors.white : AppColors.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Text(
            widget.parents[i].title,
            style: _isCurrentParentSelected ? AppTextStyles.subtitle : AppTextStyles.subtitleWhite,
          ),
        ),
      ),
    );
  }
}
