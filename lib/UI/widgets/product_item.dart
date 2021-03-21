import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/cart_controls.dart';
import 'package:tiptop_v2/UI/widgets/product_page.dart';
import 'package:tiptop_v2/models/models.dart';
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

  void openProductModal(CartProvider cartProvider) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (c) => ProductPage(
          product: widget.product,
          disableAddition: requestedMoreThanAvailableQuantity,
          quantity: productCartQuantity,
          editCartAction: (action) => editCartAction(action),
        ),
      ),
    );
  }

  Future<void> editCartAction(CartAction actionName) async {
    if (!appProvider.isAuth) {
      showToast(msg: 'You Need to Log In First!');
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
    } else {
      int _oldProductCartQuantity = productCartQuantity;
      setState(() {
        productCartQuantity = actionName == CartAction.ADD
            ? productCartQuantity + 1
            : productCartQuantity == 1
            ? 0
            : productCartQuantity - 1;
      });
      print('$actionName ${widget.product.id} ${widget.product.title}');
      try {
        int returnedProductQuantity = await cartProvider.addRemoveProduct(
          context: context,
          appProvider: appProvider,
          homeProvider: homeProvider,
          isAdding: actionName == CartAction.ADD,
          productId: widget.product.id,
        );
        requestedMoreThanAvailableQuantity = cartProvider.requestedMoreThanAvailableQuantity;
        if (requestedMoreThanAvailableQuantity) {
          print('Requested quantity: $productCartQuantity, Returned quantity: $returnedProductQuantity');
          showToast(msg: 'There are only $returnedProductQuantity available ${widget.product.title}');
          setState(() => productCartQuantity = returnedProductQuantity);
        }
      } catch (e) {
        // If an error occurred, reset the quantity
        print('An error occurred!');
        setState(() => productCartQuantity = _oldProductCartQuantity);
        throw e;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasUnitTitle = widget.product.unit != null && widget.product.unit.title != null;
    double cartButtonHeight = getCartControlButtonHeight(context);

    return Consumer<CartProvider>(
      builder: (c, cart, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height:
                getColItemHeight(3, context) + (getCartControlButtonHeight(context) / 2) + (hasUnitTitle ? CartControls.productUnitTitleHeight : 0),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => openProductModal(cart),
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
                ),
                Positioned(
                  bottom: widget.product.unit == null || widget.product.unit.title == null ? 0 : CartControls.productUnitTitleHeight,
                  left: cartControlsMargin,
                  right: cartControlsMargin,
                  height: cartButtonHeight,
                  child: CartControls(
                    product: widget.product,
                    cartButtonHeight: cartButtonHeight,
                    disableAddition: requestedMoreThanAvailableQuantity,
                    quantity: productCartQuantity,
                    editCartAction: editCartAction,
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
              onTap: () => openProductModal(cart),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10),
                  if (widget.product.discountedPrice != null)
                    FormattedPrice(
                      price: widget.product.discountedPrice.amountFormatted,
                    ),
                  FormattedPrice(price: widget.product.price.amountFormatted, isDiscounted: widget.product.discountedPrice != null),
                  if (widget.product.unitText != null) Expanded(child: Text(widget.product.unitText, style: AppTextStyles.subtitleXs50))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
