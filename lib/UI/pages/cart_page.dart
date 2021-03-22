import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/cart_product_item.dart';
import 'package:tiptop_v2/UI/widgets/order_button.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';

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
          OrderButton(
            cartProvider: cartProvider,
            isRTL: appProvider.isRTL,
          ),
        ],
      ),
    );
  }
}
