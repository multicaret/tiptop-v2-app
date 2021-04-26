import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AnimatedCartTotal extends StatelessWidget {
  final bool isRTL;
  final bool hideCart;
  final String route;
  final bool isLoading;
  final String cartTotal;

  AnimatedCartTotal({
    @required this.isRTL,
    @required this.hideCart,
    @required this.route,
    @required this.isLoading,
    @required this.cartTotal,
  });

  @override
  Widget build(BuildContext context) {
    double expandedWidth = cartTotal != null && cartTotal.length > 10 ? appBarCartTotalWidth : appBarCartTotalWidthMin;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: hideCart ? 0 : 1,
      child: GestureDetector(
        onTap: hideCart
            ? null
            : () {
                Navigator.of(context, rootNavigator: true).pushNamed(route);
              },
        child: Container(
          width: expandedWidth,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Positioned(
                width: expandedWidth,
                height: buttonHeightXs,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [const BoxShadow(blurRadius: 6, color: AppColors.shadowDark)],
                    color: AppColors.primary,
                  ),
                  child: hideCart
                      ? Text('')
                      : isLoading
                          ? SpinKitThreeBounce(
                              color: AppColors.white,
                              size: 20,
                            )
                          //Todo: convert to Html widget
                          : Text(
                              cartTotal,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: cartTotal != null && cartTotal.length > 12 ? AppTextStyles.subtitleXxsWhite : AppTextStyles.subtitleXsWhiteBold,
                              textAlign: TextAlign.end,
                            ),
                ),
              ),
              Positioned(
                height: buttonHeightXs,
                bottom: 10,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: hideCart ? expandedWidth : 30,
                  decoration: BoxDecoration(
                    borderRadius: hideCart
                        ? BorderRadius.circular(8)
                        : BorderRadius.only(
                            topLeft: Radius.circular(isRTL ? 0 : 8),
                            bottomLeft: Radius.circular(isRTL ? 0 : 8),
                            topRight: Radius.circular(isRTL ? 8 : 0),
                            bottomRight: Radius.circular(isRTL ? 8 : 0),
                          ),
                    color: AppColors.white,
                  ),
                  child: AppIcons.icon(LineAwesomeIcons.shopping_cart),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
