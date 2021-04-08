import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/market/cart_controls.dart';
import 'package:tiptop_v2/UI/pages/market/product_page.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../../UI/formatted_price.dart';

class MarketGridProductItem extends StatelessWidget {
  final Product product;

  const MarketGridProductItem({@required this.product});

  void openProductPage(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed(ProductPage.routeName, arguments: {
      "product": product,
      "has_controls": true,
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasUnitTitle = product.unit != null && product.unit.title != null;
    bool hasDiscountedPrice = product.discountedPrice != null && product.discountedPrice.raw != 0;
    // print('rebuilt grid product item ${product.title}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: getColItemHeight(3, context) + (getCartControlButtonHeight(context) / 2) + (hasUnitTitle ? marketProductUnitTitleHeight : 0),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => openProductPage(context),
                child: Consumer<CartProvider>(builder: (c, cartProvider, _) {
                  int productCartQuantity = cartProvider.getProductQuantity(product.id);

                  return GestureDetector(
                    onTap: () => openProductPage(context),
                    child: Container(
                      height: getColItemHeight(3, context),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5, color: productCartQuantity > 0 ? AppColors.primary : AppColors.border),
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(product.media.coverThumbnail),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Positioned(
                bottom: product.unit == null || product.unit.title == null ? 0 : marketProductUnitTitleHeight,
                left: cartControlsMargin,
                right: cartControlsMargin,
                height: getCartControlButtonHeight(context),
                child: CartControls(
                  product: product
                ),
              ),
              if (hasUnitTitle)
                Positioned(
                  bottom: 0,
                  height: marketProductUnitTitleHeight,
                  right: 0,
                  left: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      product.unit.title,
                      style: AppTextStyles.subtitleXxs50,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => openProductPage(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: AppTextStyles.subtitle,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                if (hasDiscountedPrice)
                  FormattedPrice(
                    price: product.discountedPrice.formatted,
                  ),
                FormattedPrice(price: product.price.formatted, isDiscounted: hasDiscountedPrice),
                if (product.unitText != null) Expanded(child: Text(product.unitText, style: AppTextStyles.subtitleXs50))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
