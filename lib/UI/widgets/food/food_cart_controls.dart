import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FoodCartControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
      color: AppColors.bg,
      child: Consumer<ProductsProvider>(
        builder: (c, productsProvider, _) {
          int quantity = productsProvider.productTempCartData.quantity;

          return Container(
            height: buttonHeightSm,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Remove button
                Expanded(
                  child: InkWell(
                    onTap: () => productsProvider.setProductTempQuantity(CartAction.REMOVE),
                    child: Container(
                      child: AppIcons.iconWhite(FontAwesomeIcons.minus),
                    ),
                  ),
                ),
                //Quantity
                Expanded(
                  child: Container(
                    color: AppColors.white,
                    alignment: Alignment.center,
                    child: Text(
                      '$quantity',
                      style: AppTextStyles.bodyBold,
                    ),
                  ),
                ),
                //Add button
                Expanded(
                  child: InkWell(
                    onTap: () => productsProvider.setProductTempQuantity(CartAction.ADD),
                    child: Container(
                      child: AppIcons.iconWhite(FontAwesomeIcons.plus),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
