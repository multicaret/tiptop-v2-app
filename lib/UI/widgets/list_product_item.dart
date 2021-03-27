import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/cart_controls.dart';
import 'package:tiptop_v2/UI/widgets/product_page.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'formatted_price.dart';

class ListGridProductItem extends StatelessWidget {
  final int quantity;
  final Product product;
  final bool hasControls;

  ListGridProductItem({
    @required this.quantity,
    @required this.product,
    this.hasControls = true,
  });

  @override
  Widget build(BuildContext context) {
    bool hasDiscountedPrice = product.discountedPrice != null && product.discountedPrice.raw != 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(width: 1.5, color: AppColors.border),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(ProductPage.routeName, arguments: product),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 1.5),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(product.media.cover),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(ProductPage.routeName, arguments: product),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title),
                    SizedBox(height: 10),
                    if (product.unitText != null) Text(product.unitText, style: AppTextStyles.subtitleXs50),
                    if (hasDiscountedPrice)
                      FormattedPrice(
                        price: product.discountedPrice.formatted,
                      ),
                    FormattedPrice(
                      price: product.price.formatted,
                      isDiscounted: hasDiscountedPrice,
                    ),
                  ],
                ),
              ),
            ),
          ),
          hasControls
              ? Container(
                  width: 99,
                  height: 33,
                  child: CartControls(product: product, cartButtonHeight: 33),
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bg,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text('$quantity'),
                )
        ],
      ),
    );
  }
}
