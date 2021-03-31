import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tiptop_v2/UI/widgets/market/products/products_grid_view.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ChildCategoryProducts extends StatefulWidget {
  final Category child;
  final int index;
  final int count;
  final AutoScrollController productsScrollController;
  final Function scrollSpyAction;
  final List<Map<String, dynamic>> categoriesHeights;

  ChildCategoryProducts({
    @required this.child,
    @required this.index,
    @required this.count,
    @required this.productsScrollController,
    @required this.scrollSpyAction,
    @required this.categoriesHeights,
  });

  @override
  _ChildCategoryProductsState createState() => _ChildCategoryProductsState();
}

class _ChildCategoryProductsState extends State<ChildCategoryProducts> {
  GlobalKey key = GlobalKey();
  double categoryPosition = 0;
  double headerHeight = 200;
  double currentCategoryHeight;
  double previousCategoriesHeights = 0;

  void childCategoriesScrollListener() {
    double scrollPosition = widget.productsScrollController.position.pixels;
    if (scrollPosition <= headerHeight) {
      widget.scrollSpyAction(0);
    } else {
      if (scrollPosition >= previousCategoriesHeights && scrollPosition < currentCategoryHeight + previousCategoriesHeights) {
        widget.scrollSpyAction(widget.index);
      } else if (scrollPosition == widget.productsScrollController.position.maxScrollExtent) {
        widget.scrollSpyAction(widget.count - 1);
      }
    }
  }

  @override
  void initState() {
    widget.productsScrollController.addListener(childCategoriesScrollListener);
    currentCategoryHeight = widget.categoriesHeights[widget.index]['height'];
    if (widget.index > 0) {
      for (int i = widget.index - 1; i >= 0; i--) {
        previousCategoriesHeights += widget.categoriesHeights[i]['height'];
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    widget.productsScrollController.removeListener(childCategoriesScrollListener);
    super.dispose();
  }
  int count = 1;

  @override
  Widget build(BuildContext context) {
    List<Product> products = widget.child.products;
    print('Built ${widget.child.title} widget ${count++} times!!!');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (widget.index != 0)
          Container(
            padding: EdgeInsets.only(right: 17, left: 17, top: 30, bottom: 5),
            color: AppColors.bg,
            child: Text(
              widget.child.title,
              style: AppTextStyles.body50,
            ),
          ),
        Container(
          color: AppColors.white,
          height: widget.categoriesHeights[widget.index]['height'],
          child: AutoScrollTag(
            controller: widget.productsScrollController,
            index: widget.index,
            key: ValueKey(widget.index),
            child: ProductsGridView(products: products),
          ),
        ),
      ],
    );
  }
}
