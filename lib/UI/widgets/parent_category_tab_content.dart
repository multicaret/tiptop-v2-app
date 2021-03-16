import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

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
    );

    selectedChildCategoryId = widget.children[0].id;
    super.initState();
  }

  void scrollTo(int index) {
    childCategoriesScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );

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
            scrollTo(i);
          },
        ),
        Expanded(
          child: ListView(
            children: List.generate(
              widget.children.length,
              (i) => childCategoryProducts(
                index: i,
                child: widget.children[i],
              ),
            ),
            controller: productsScrollController,
          ),
        )
      ],
    );
  }

  Widget childCategoryProducts({Category child, int index}) {
    List<Product> products = child.products;

    return Column(
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
    );
  }
}
