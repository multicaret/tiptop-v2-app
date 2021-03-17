import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/cart_controls.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
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
  CartProvider cartProvider;
  bool _isInit = true;

  Future<void> editCartAction(String actionName) async {
    if (!appProvider.isAuth) {
      showToast(msg: 'You Need to Log In First!');
      Navigator.of(context).pushReplacementNamed(WalkthroughPage.routeName);
    } else {
      if (actionName == 'add') {
        //Add item
        final response = await cartProvider.addRemoveProduct(
          appProvider,
          isAdding: true,
          productId: widget.product.id,
        );
        //Unauthenticated, navigate to auth page
        if (response == 401) {
          showToast(msg: 'You need to log in first!');
          Navigator.of(context).pushReplacementNamed(WalkthroughPage.routeName);
          return;
        }
        setState(() {
          productCartQuantity++;
        });
      } else if (actionName == 'remove') {
        //Remove item
        setState(() {
          if (productCartQuantity > 1) {
            productCartQuantity--;
          } else {
            productCartQuantity = 0;
          }
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      cartProvider = Provider.of<CartProvider>(context);
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
