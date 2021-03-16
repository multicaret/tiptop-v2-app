import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChildCategoryProducts extends StatelessWidget {
  final Category child;
  final int index;
  final Function action;
  final AutoScrollController productsScrollController;

  ChildCategoryProducts({
    @required this.child,
    @required this.index,
    @required this.action,
    @required this.productsScrollController,
  });

  @override
  Widget build(BuildContext context) {
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
          action(index);
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
