import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/market/products/market_grid_product_item.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/ui_helper.dart';

class MarketProductsGridView extends StatelessWidget {
  final List<Product> products;
  final ScrollPhysics physics;
  final String categoryEnglishTitle;
  final String parentCategoryEnglishTitle;

  const MarketProductsGridView({
    @required this.products,
    this.physics,
    this.categoryEnglishTitle,
    this.parentCategoryEnglishTitle,
  });

  @override
  Widget build(BuildContext context) {
    double productGridItemWidth = getColItemHeight(3, context);
    double productGridItemHeight = getProductGridItemHeight(context);
    double productGridItemAspectRatio = productGridItemWidth / productGridItemHeight;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10),
      physics: physics ?? NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        childAspectRatio: productGridItemAspectRatio,
      ),
      itemBuilder: (c, i) => MarketGridProductItem(
        product: products[i],
        categoryEnglishTitle: categoryEnglishTitle,
        parentCategoryEnglishTitle: parentCategoryEnglishTitle,
      ),
    );
  }
}
