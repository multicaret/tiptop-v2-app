import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'child_categories_tabs.dart';

class ParentCategoryTabContent extends StatefulWidget {
  final List<Category> children;

  ParentCategoryTabContent({@required this.children});

  @override
  _ParentCategoryTabContentState createState() => _ParentCategoryTabContentState();
}

class _ParentCategoryTabContentState extends State<ParentCategoryTabContent> {
  int selectedChildCategoryId;

  AutoScrollController childCategoriesScrollController;
  final childCategoriesScrollDirection = Axis.horizontal;

  AutoScrollController productsScrollController;
  final productsScrollDirection = Axis.horizontal;

  @override
  void initState() {
    childCategoriesScrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: childCategoriesScrollDirection,
    );

    productsScrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: childCategoriesScrollDirection,
    )..addListener(() {
        // print("offset = ${productsScrollController.offset}");
      });

    selectedChildCategoryId = widget.children[0].id;
    super.initState();
  }

  void scrollToCategoryAndProducts(int index) {
    scrollToCategory(index);
    scrollToProducts(index);
  }

  void scrollToCategory(int index) {
    childCategoriesScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  void scrollToProducts(int index) {
    productsScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChildCategoriesTabs(
          children: widget.children,
          itemScrollController: childCategoriesScrollController,
          selectedChildCategoryId: selectedChildCategoryId,
          action: (i) {
            setState(() {
              selectedChildCategoryId = widget.children[i].id;
            });
            scrollToCategoryAndProducts(i);
          },
        ),
        Expanded(
          child: ListView(
            children: List.generate(
              widget.children.length,
              (i) => childCategoryProducts(
                index: i,
                child: widget.children[i],
                context: context,
              ),
            ),
            controller: productsScrollController,
          ),
        )
      ],
    );
  }

  int previousProductsVisibility = 0;
  int currentProductsVisibility = 0;

  List<int> visibilityPercentages = [];

  Widget childCategoryProducts({Category child, int index, BuildContext context}) {
    List<Product> products = child.products;
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    int productsAreaHeight = screenHeight.round() - 56 - 50 - 50 - 200;

    return VisibilityDetector(
      key: ValueKey(index),
      onVisibilityChanged: (visibilityInfo) {
        int visibilityPercentage = (visibilityInfo.visibleFraction * 100).round();
        int _productsVisibleHeight = (visibilityInfo.size.height).round();
        bool _largeCategoryInView = _productsVisibleHeight > productsAreaHeight - 10 && _productsVisibleHeight < productsAreaHeight + 10;
        bool _smallCategoryInView = visibilityPercentage > 80 && visibilityPercentage <= 100;
        if (_smallCategoryInView || _largeCategoryInView) {
          setState(() {
            selectedChildCategoryId = widget.children[index].id;
          });
          scrollToCategory(index);
        }
        // }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (index != 0)
            Container(
              padding: EdgeInsets.only(right: 17, left: 17, top: 30, bottom: 5),
              color: AppColors.bg,
              child: Text(
                child.title,
                style: AppTextStyles.body50,
              ),
            ),
          AutoScrollTag(
            controller: productsScrollController,
            index: index,
            key: ValueKey(index),
            child: GridView.count(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                ...products.map((product) => Container(
                      height: 200,
                      color: AppColors.secondaryDark,
                      child: Center(child: Text(product.title)),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
