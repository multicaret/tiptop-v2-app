import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/market/products/grid_product_item.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/helper.dart';

class ProductsGridView extends StatelessWidget {
  final List<Product> products;
  final ScrollPhysics physics;

  const ProductsGridView({
    @required this.products,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    double productGridItemWidth = getColItemHeight(3, context);
    double productGridItemHeight = getProductGridItemHeight(context);
    double productGridItemAspectRatio = productGridItemWidth / productGridItemHeight;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      physics: physics ?? NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        childAspectRatio: productGridItemAspectRatio,
      ),
      itemBuilder: (c, i) => GridProductItem(product: products[i]),
    );
  }
}
