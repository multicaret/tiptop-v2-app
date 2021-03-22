import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/cart_product_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isInit = true;
  CartProvider cartProvider;
  AppProvider appProvider;

  ScrollController _controller;
  bool popFlag = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent - 100 && popFlag == false) {
      popFlag = true;
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      cartProvider = Provider.of<CartProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(title: Text(Translations.of(context).get('Cart')), actions: [
        IconButton(
          onPressed: () {
            //Todo: implement clear cart request WITH ALERT DIALOG
          },
          icon: AppIcon.iconPrimary(FontAwesomeIcons.trashAlt),
        )
      ]),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(bottom: 105),
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _controller,
                children: cartProvider.cartProducts
                    .map((cartProduct) => CartProductItem(
                          product: cartProduct.product,
                          quantity: cartProduct.quantity,
                        ))
                    .toList(),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                color: AppColors.primary,
                padding: EdgeInsets.only(top: 20, bottom: 40, left: 17, right: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        child: Text(Translations.of(context).get('Order Now')),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryDark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(appProvider.isRTL ? 0 : 8),
                            bottomLeft: Radius.circular(appProvider.isRTL ? 0 : 8),
                            topRight: Radius.circular(appProvider.isRTL ? 8 : 0),
                            bottomRight: Radius.circular(appProvider.isRTL ? 8 : 0),
                          ),
                          boxShadow: [
                            BoxShadow(color: AppColors.shadowDark, blurRadius: 6),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(appProvider.isRTL ? 0 : 8),
                          bottomRight: Radius.circular(appProvider.isRTL ? 0 : 8),
                          topLeft: Radius.circular(appProvider.isRTL ? 8 : 0),
                          bottomLeft: Radius.circular(appProvider.isRTL ? 8 : 0),
                        ),
                        boxShadow: [
                          BoxShadow(color: AppColors.shadowDark, blurRadius: 6),
                        ],
                      ),
                      child: cartProvider.isLoadingAddRemoveRequest
                          ? SpinKitThreeBounce(
                              color: AppColors.primary,
                              size: 20,
                            )
                          : Text(
                              cartProvider.cartTotal,
                              style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w400),
                            ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
