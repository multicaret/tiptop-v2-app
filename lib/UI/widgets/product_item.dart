import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/cart_controls.dart';
import 'package:tiptop_v2/UI/widgets/price.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
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
  int productCartQuantity = 0;
  AppProvider appProvider;
  HomeProvider homeProvider;
  CartProvider cartProvider;
  bool _isInit = true;
  bool _isLoadingAddRemoveRequest = false;

  Future<void> editCartAction(String actionName) async {
    if (!appProvider.isAuth) {
      showToast(msg: 'You Need to Log In First!');
      Navigator.of(context).pushReplacementNamed(WalkthroughPage.routeName);
    } else {
      setState(() {
        _isLoadingAddRemoveRequest = true;
      });
      //Add item
      print('$actionName ${widget.product.id} ${widget.product.title}');
      await cartProvider.addRemoveProduct(
        context: context,
        appProvider: appProvider,
        homeProvider: homeProvider,
        isAdding: actionName == 'add',
        productId: widget.product.id,
      );

      setState(() {
        _isLoadingAddRemoveRequest = false;
        productCartQuantity = actionName == 'add'
            ? productCartQuantity + 1
            : productCartQuantity == 1
                ? 0
                : productCartQuantity - 1;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      cartProvider = Provider.of<CartProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
    }
    _isInit = false;
    super.didChangeDependencies();
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
              AnimatedContainer(
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
              CartControls(
                product: widget.product,
                isZero: productCartQuantity == 0,
                quantity: productCartQuantity,
                editCartAction: (actionName) => editCartAction(actionName),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          widget.product.title,
          style: AppTextStyles.subtitle,
        ),
        SizedBox(height: 10),
        Price(price: widget.product.price.amountFormatted),
        if (widget.product.discountedPrice != null && widget.product.discountedPrice.amountRaw != 0)
          Price(
            price: widget.product.discountedPrice.amountFormatted,
            isDiscounted: true,
          ),
        if (widget.product.unitText != null) Expanded(child: Text(widget.product.unitText, style: AppTextStyles.subtitleXs50))
      ],
    );
  }
}
