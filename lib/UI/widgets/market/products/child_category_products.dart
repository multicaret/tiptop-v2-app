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

  ChildCategoryProducts({
    @required this.child,
    @required this.index,
    @required this.count,
    @required this.productsScrollController,
    @required this.scrollSpyAction,
  });

  @override
  _ChildCategoryProductsState createState() => _ChildCategoryProductsState();
}

class _ChildCategoryProductsState extends State<ChildCategoryProducts> {
  GlobalKey key = GlobalKey();
  double categoryPosition = 0;
  double firstCategoryPosition = 200;

  void categoryReachedTopScrollListener() {
    double scrollPosition = widget.productsScrollController.position.pixels;
    double scrollPositionWithTopBars = widget.productsScrollController.position.pixels + firstCategoryPosition;
    // print('${widget.child.title} category position: $categoryPosition');
    // print('scroll position with top bars: $scrollPositionWithTopBars');

    if (scrollPosition == 0) {
      widget.scrollSpyAction(0);
    } else if (scrollPosition == widget.productsScrollController.position.maxScrollExtent) {
      widget.scrollSpyAction(widget.count - 1);
    } else if (scrollPositionWithTopBars >= categoryPosition && scrollPositionWithTopBars < categoryPosition + 30) {
      widget.scrollSpyAction(widget.index);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_getPositions);
    widget.productsScrollController.addListener(categoryReachedTopScrollListener);
    super.initState();
  }

  _getPositions(_) {
    if (key.currentContext != null) {
      final RenderBox renderBoxRed = key.currentContext.findRenderObject();
      final positionRed = renderBoxRed.localToGlobal(Offset.zero);
      setState(() {
        if (widget.index == 0) {
          firstCategoryPosition = positionRed.dy;
        }
        categoryPosition = positionRed.dy;
      });
    }
  }

  @override
  void dispose() {
    widget.productsScrollController.removeListener(categoryReachedTopScrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = widget.child.products;
    //Todo: Uncomment this print to see the horror 🤬
    // print('Rebuilt ${widget.child.title} widget!!! 🤬');

    return Column(
      key: key,
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
