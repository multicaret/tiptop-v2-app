import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/food_category_item.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/constants.dart';

class CategoriesSlider extends StatefulWidget {
  final List<Category> categories;
  final bool isRTL;
  final bool isCategorySelectable;

  CategoriesSlider({
    @required this.categories,
    @required this.isRTL,
    this.isCategorySelectable = false,
  });

  @override
  _CategoriesSliderState createState() => _CategoriesSliderState();
}

class _CategoriesSliderState extends State<CategoriesSlider> {
  int selectedIndex;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: restaurantCategoriesHeight,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 10);
        },
        itemCount: widget.categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => FoodCategoryItem(
          category: widget.categories[i],
          index: i,
          count: widget.categories.length,
          isRTL: widget.isRTL,
          isSelectable: widget.isCategorySelectable,
          onTap: () {
            setState(() {
              selectedIndex = i;
            });
          },
          isSelected: selectedIndex == i,
        ),
      ),
    );
  }
}
