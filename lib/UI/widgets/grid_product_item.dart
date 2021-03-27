import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/cart_controls.dart';
import 'package:tiptop_v2/UI/widgets/product_page.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'formatted_price.dart';

class ProductItem extends StatefulWidget {
  final Product product;

  const ProductItem({@required this.product});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  AppProvider appProvider;
  HomeProvider homeProvider;
  CartProvider cartProvider;
  bool _isInit = true;
  bool requestedMoreThanAvailableQuantity = false;
  int productCartQuantity;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      cartProvider = Provider.of<CartProvider>(context);
      productCartQuantity = cartProvider.getProductQuantity(widget.product.id);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool hasUnitTitle = widget.product.unit != null && widget.product.unit.title != null;
    bool hasDiscountedPrice = widget.product.discountedPrice != null && widget.product.discountedPrice.raw != 0;
    double cartButtonHeight = getCartControlButtonHeight(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: getColItemHeight(3, context) + (getCartControlButtonHeight(context) / 2) + (hasUnitTitle ? CartControls.productUnitTitleHeight : 0),
          child: Stack(
            children: [
              Consumer<CartProvider>(builder: (c, cartProvider, _) {
                int productCartQuantity = cartProvider.getProductQuantity(widget.product.id);

                return GestureDetector(
                  onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(ProductPage.routeName, arguments: widget.product),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: getColItemHeight(3, context),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: productCartQuantity > 0 ? AppColors.primary : AppColors.border),
                      borderRadius: BorderRadius.circular(14),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.product.media.cover),
                      ),
                    ),
                  ),
                );
              }),
              Positioned(
                bottom: widget.product.unit == null || widget.product.unit.title == null ? 0 : CartControls.productUnitTitleHeight,
                left: cartControlsMargin,
                right: cartControlsMargin,
                height: cartButtonHeight,
                child: CartControls(
                  product: widget.product,
                  cartButtonHeight: cartButtonHeight,
                ),
              ),
              if (hasUnitTitle)
                Positioned(
                  bottom: 0,
                  height: CartControls.productUnitTitleHeight,
                  right: 0,
                  left: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      widget.product.unit.title,
                      style: AppTextStyles.subtitleXxs50,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(ProductPage.routeName, arguments: widget.product),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.title,
                  style: AppTextStyles.subtitle,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                if (hasDiscountedPrice)
                  FormattedPrice(
                    price: widget.product.discountedPrice.formatted,
                  ),
                FormattedPrice(price: widget.product.price.formatted, isDiscounted: hasDiscountedPrice),
                if (widget.product.unitText != null) Expanded(child: Text(widget.product.unitText, style: AppTextStyles.subtitleXs50))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
