import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/product_item.dart';
import 'package:tiptop_v2/models/product.dart';

class ProductsGridView extends StatelessWidget {
  final List<Product> products;
  final ScrollPhysics physics;

  const ProductsGridView({
    @required this.products,
    this.physics,
  });


  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      physics: physics ?? NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 3,
      childAspectRatio: 0.45,
      children: <Widget>[...products.map((product) => ProductItem(product: product))],
    );
  }
}
