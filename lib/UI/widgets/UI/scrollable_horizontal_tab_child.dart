import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ScrollableHorizontalTabChild extends StatelessWidget {
  final Function action;
  final int index;
  final AutoScrollController scrollController;
  final bool isInverted;
  final bool isSelected;
  final Category childCategory;

  const ScrollableHorizontalTabChild({
    @required this.action,
    @required this.index,
    @required this.scrollController,
    @required this.isInverted,
    @required this.isSelected,
    @required this.childCategory,
  });

  @override
  Widget build(BuildContext context) {
    return AutoScrollTag(
      controller: scrollController,
      index: index,
      key: ValueKey(index),
      child: InkWell(
        onTap: () => action(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: isSelected ? 10 : 0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isInverted
                ? isSelected
                    ? AppColors.white
                    : AppColors.primary
                : isSelected
                    ? AppColors.primary
                    : AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            childCategory.title,
            style: isInverted
                ? isSelected
                    ? AppTextStyles.subtitle
                    : AppTextStyles.subtitleWhite
                : isSelected
                    ? AppTextStyles.subtitleWhite
                    : AppTextStyles.subtitle,
          ),
        ),
      ),
    );
  }
}
