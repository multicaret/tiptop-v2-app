import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/food_product_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/food/products/selected_options_text.dart';
import 'package:tiptop_v2/UI/widgets/formatted_prices.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

import '../food_cart_controls.dart';

class FoodCartProductListItem extends StatelessWidget {
  final int restaurantId;
  final int chainId;
  final CartProduct cartProduct;
  final bool hasControls;
  final Function dismissAction;
  final bool editableCartProduct;
  final Function editQuantityAction;
  final bool isLoadingAdjustQuantity;

  FoodCartProductListItem({
    @required this.restaurantId,
    @required this.chainId,
    @required this.cartProduct,
    this.hasControls = true,
    this.dismissAction,
    this.editableCartProduct = true,
    this.editQuantityAction,
    this.isLoadingAdjustQuantity = false,
  });

  @override
  Widget build(BuildContext context) {
    return editableCartProduct
        ? Dismissible(
            key: Key('${cartProduct.cartProductId}'),
            direction: DismissDirection.endToStart,
            background: Consumer<AppProvider>(
              builder: (c, appProvider, _) => Container(
                color: Colors.red,
                alignment: appProvider.isRTL ? Alignment.centerLeft : Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
                child: AppIcons.iconMdWhite(FontAwesomeIcons.trashAlt),
              ),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                final response = await showDialog(
                  context: context,
                  builder: (context) => ConfirmAlertDialog(
                    title: 'Are you sure you want to delete this product from your cart?',
                  ),
                );
                return response == null ? false : response;
              }
              return false;
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                dismissAction();
              }
            },
            child: _getCartListItem(context),
          )
        : _getCartListItem(context);
  }

  Widget _getCartListItem(BuildContext context) {
    void openFoodProductPage() {
      Navigator.of(context, rootNavigator: true).pushNamed(
        FoodProductPage.routeName,
        arguments: {
          "product_id": cartProduct.product.id,
          "has_controls": hasControls,
          "cart_product": editableCartProduct ? cartProduct : null,
          'chain_id': chainId,
          'restaurant_id': restaurantId,
        },
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: AppColors.border),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: openFoodProductPage,
            child: Container(
              width: productListItemThumbnailSize,
              height: productListItemThumbnailSize,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 1.5),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(cartProduct.product.media.coverThumbnail),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: openFoodProductPage,
              child: Container(
                constraints: BoxConstraints(minHeight: productListItemThumbnailSize),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cartProduct.product.title),
                    const SizedBox(height: 10),
                    if (cartProduct.selectedOptions.length > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SelectedOptionsText(cartProduct: cartProduct),
                      ),
                    FormattedPrices(
                      price: cartProduct.totalPrice,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (hasControls)
            Container(
              width: 99,
              height: 33,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
              ),
              child: FoodCartControls(
                quantity: cartProduct.quantity,
                isLoadingQuantity: isLoadingAdjustQuantity,
                action: editQuantityAction,
                isMin: true,
              ),
            ),
          if (cartProduct.quantity != null && !hasControls)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bg,
              ),
              padding: const EdgeInsets.all(10),
              child: Text('${cartProduct.quantity}'),
            )
        ],
      ),
    );
  }
}
