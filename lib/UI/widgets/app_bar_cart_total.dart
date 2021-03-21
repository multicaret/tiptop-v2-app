import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/cart_page.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AppBarCartTotal extends StatelessWidget {
  final bool isLoadingHomeData;

  AppBarCartTotal({@required this.isLoadingHomeData});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Consumer<CartProvider>(
      builder: (c, cart, _) {
        bool noCart = cart.noCart();

        return AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: isLoadingHomeData || noCart ? 0 : 1,
          child: GestureDetector(
            onTap: () => appWrapperKey.currentState.onTabItemTapped(2),
            child: Container(
              width: 130,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: appProvider.isRTL ? 10 : 0, right: appProvider.isRTL ? 0 : 10),
              child: Stack(
                children: [
                  Positioned(
                    height: 33,
                    width: 130,
                    bottom: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(blurRadius: 6, color: AppColors.shadowDark)],
                        color: AppColors.primary,
                      ),
                      child: isLoadingHomeData || noCart
                          ? Text('')
                          : Text(
                              cart.cartTotal,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: cart.cartTotal != null && cart.cartTotal.length > 12
                                  ? AppTextStyles.subtitleXxsWhite
                                  : AppTextStyles.subtitleXsWhiteBold,
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                  Positioned(
                    height: 33,
                    bottom: 10,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: isLoadingHomeData || noCart ? 130 : 30,
                      decoration: BoxDecoration(
                        borderRadius: isLoadingHomeData || noCart
                            ? BorderRadius.circular(8)
                            : BorderRadius.only(
                                topLeft: Radius.circular(appProvider.isRTL ? 0 : 8),
                                bottomLeft: Radius.circular(appProvider.isRTL ? 0 : 8),
                                topRight: Radius.circular(appProvider.isRTL ? 8 : 0),
                                bottomRight: Radius.circular(appProvider.isRTL ? 8 : 0),
                              ),
                        color: AppColors.white,
                      ),
                      child: AppIcon.icon(LineAwesomeIcons.shopping_cart),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
