import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/cart_controls.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class ProductItem extends StatefulWidget {
  final Product product;

  const ProductItem({@required this.product});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool productAddedToBasket = false;

  void editCartAction(String actionName) {
    if (actionName == 'add') {
      //Add item
      setState(() {
        productAddedToBasket = true;
      });
    } else if (actionName == 'remove') {
      //Remove item
      setState(() {
        productAddedToBasket = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: getColItemHeight(3, context) + (getCartControlButtonHeight(context) / 2),
          child: Stack(
            children: [
              Container(
                height: getColItemHeight(3, context),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: productAddedToBasket ? AppColors.primary : AppColors.border),
                  borderRadius: BorderRadius.circular(14),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.product.media.cover),
                  ),
                ),
              ),
              CartControls(
                product: widget.product,
                isZero: !productAddedToBasket,
                editCartAction: (actionName) => editCartAction(actionName),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Text(
            widget.product.title,
            style: AppTextStyles.subtitle,
          ),
        )
      ],
    );
  }
}
