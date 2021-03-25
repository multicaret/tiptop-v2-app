import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CartControls extends StatefulWidget {
  final Product product;
  final double cartButtonHeight;
  final bool isModalControls;

  CartControls({
    @required this.product,
    @required this.cartButtonHeight,
    this.isModalControls = false,
  });

  static double productUnitTitleHeight = 12;

  @override
  _CartControlsState createState() => _CartControlsState();
}

class _CartControlsState extends State<CartControls> {
  AppProvider appProvider;
  HomeProvider homeProvider;
  CartProvider cartProvider;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> editCartAction(CartAction action, CartProvider cartProvider) async {
    if (!appProvider.isAuth) {
      showToast(msg: 'You Need to Log In First!');
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
    } else {
      print('$action ${widget.product.id} ${widget.product.title}');
      await cartProvider.addRemoveProduct(
        context: context,
        appProvider: appProvider,
        homeProvider: homeProvider,
        isAdding: action == CartAction.ADD,
        product: widget.product,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    Size screenSize = MediaQuery.of(context).size;
    double screenThirdWidth = (screenSize.width - (17 * 2)) / 3;

    return Consumer<CartProvider>(builder: (c, cartProvider, _) {
      int quantity = cartProvider.getProductQuantity(widget.product.id);
      bool disableAddition = cartProvider.requestedMoreThanAvailableQuantity[widget.product.id] == null
          ? false
          : cartProvider.requestedMoreThanAvailableQuantity[widget.product.id];
      return Stack(
        children: [
          //Quantity
          Positioned(
            left: widget.isModalControls ? screenThirdWidth : widget.cartButtonHeight,
            height: widget.cartButtonHeight,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: widget.isModalControls ? screenThirdWidth : widget.cartButtonHeight,
              height: widget.cartButtonHeight,
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(quantity == 0 ? 10 : 0), boxShadow: [
                BoxShadow(blurRadius: 6, color: AppColors.shadow),
              ]),
              child: Center(
                child: Text(
                  quantity == 0 ? '' : '$quantity',
                  style: quantity.toString().length >= 2 ? AppTextStyles.subtitleXsBold : AppTextStyles.subtitleBold,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
          //Remove Button
          buttonAnimatedContainer(
            context: context,
            action: CartAction.REMOVE,
            isRTL: appProvider.isRTL,
            screenThirdWidth: screenThirdWidth,
            quantity: quantity,
            cartProvider: cartProvider,
          ),
          //Add Button
          buttonAnimatedContainer(
            context: context,
            action: CartAction.ADD,
            isRTL: appProvider.isRTL,
            screenThirdWidth: screenThirdWidth,
            quantity: quantity,
            disableAddition: disableAddition,
            cartProvider: cartProvider,
          ),
          if (widget.isModalControls)
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              right: 0,
              left: 0,
              top: quantity == 0 ? 0 : widget.cartButtonHeight,
              bottom: quantity == 0 ? 0 : -widget.cartButtonHeight,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: quantity == 0 ? 1 : 0,
                child: ElevatedButton(
                  onPressed: () => editCartAction(CartAction.ADD, cartProvider),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcon.iconWhite(LineAwesomeIcons.shopping_cart),
                      SizedBox(width: 5),
                      Text(
                        'Add to Cart',
                        style: AppTextStyles.button,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  double getLeftOffset(CartAction action, bool isRTL, double cartButtonHeight, int quantity) {
    if (action == CartAction.ADD) {
      return quantity == 0
          ? cartButtonHeight
          : isRTL
              ? 0
              : cartButtonHeight * 2;
    } else if (action == CartAction.REMOVE) {
      return quantity == 0
          ? cartButtonHeight
          : isRTL
              ? cartButtonHeight * 2
              : 0;
    } else {
      return 0;
    }
  }

  BorderRadius getBorderRadius(CartAction action, bool isRTL, int quantity) {
    if (action == CartAction.ADD) {
      return BorderRadius.only(
        topLeft: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
        bottomLeft: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
        topRight: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
        bottomRight: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
      );
    } else if (action == CartAction.REMOVE) {
      return BorderRadius.only(
        topLeft: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
        bottomLeft: Radius.circular(quantity == 0 || !isRTL ? 10 : 0),
        topRight: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
        bottomRight: Radius.circular(quantity == 0 || isRTL ? 10 : 0),
      );
    } else {
      return BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
    }
  }

  double getModalLeftOffset(double screenThirdWidth, CartAction action, bool isRTL) {
    if (action == CartAction.ADD) {
      return isRTL ? 0 : screenThirdWidth * 2;
    } else {
      return isRTL ? screenThirdWidth * 2 : 0;
    }
  }

  Widget buttonAnimatedContainer({
    @required BuildContext context,
    @required CartAction action,
    @required bool isRTL,
    @required double screenThirdWidth,
    @required int quantity,
    @required CartProvider cartProvider,
    bool disableAddition = false,
  }) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 200),
      left: widget.isModalControls
          ? getModalLeftOffset(screenThirdWidth, action, isRTL)
          : getLeftOffset(action, isRTL, widget.cartButtonHeight, quantity),
      child: InkWell(
        onTap: disableAddition ? null : () => editCartAction(action, cartProvider),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: widget.cartButtonHeight,
          width: widget.isModalControls ? screenThirdWidth : widget.cartButtonHeight,
          decoration: BoxDecoration(
            color: disableAddition ? AppColors.disabled : AppColors.primary,
            borderRadius: getBorderRadius(action, isRTL, quantity),
            boxShadow: [
              BoxShadow(blurRadius: 6, color: AppColors.shadow),
            ],
          ),
          child: disableAddition
              ? AppIcon.iconXsWhite50(FontAwesomeIcons.plus)
              : AppIcon.iconXsWhite(
                  action == CartAction.ADD
                      ? FontAwesomeIcons.plus
                      : quantity == 1
                          ? FontAwesomeIcons.trashAlt
                          : FontAwesomeIcons.minus,
                ),
        ),
      ),
    );
  }
}
