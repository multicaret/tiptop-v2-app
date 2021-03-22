import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/cart_controls.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class CartProductItem extends StatelessWidget {
  final int quantity;
  final Product product;

  CartProductItem({
    @required this.quantity,
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Text(product.title),
/*          Container(
            width: 100,
            child: CartControls(product: product, cartButtonHeight: 33),
          )*/
        ],
      ),
    );
  }
}
