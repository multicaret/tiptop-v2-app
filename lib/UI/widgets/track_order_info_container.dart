import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_previous_order_page.dart';
import 'package:tiptop_v2/UI/pages/market/order/market_previous_order_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/triangle_painter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class TrackOrderInfoContainer extends StatefulWidget {
  final Order order;
  final bool channelIsMarket;

  TrackOrderInfoContainer({@required this.order, this.channelIsMarket = true});

  @override
  _TrackOrderInfoContainerState createState() => _TrackOrderInfoContainerState();
}

class _TrackOrderInfoContainerState extends State<TrackOrderInfoContainer> {
  double sliderValue = 0;
  double leftPosition = 30;
  double sliderIndicatorWidth = 55.0;
  double sliderIndicatorHeight = 65.0;
  double sliderSideGutter = 20;

  List<String> orderStatusTexts = [
    "Preparing",
    "On the way",
    "At the address",
    "Delivered",
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double infoContainerWidth = screenSize.width - (screenHorizontalPadding * 2);
    print('Order status: ${widget.order.status}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<AppProvider>(
          child: Column(
            children: [
              Container(
                width: sliderIndicatorWidth,
                height: sliderIndicatorWidth,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [const BoxShadow(blurRadius: 7, color: AppColors.shadow)],
                  color: AppColors.white,
                ),
                child: Image.asset(
                  getOrderTrackingSliderData(widget.order.status)['icon'],
                  width: 35,
                  height: 40,
                ),
              ),
              CustomPaint(
                size: Size(15.0, 10.0),
                painter: TrianglePainter(isDown: true, color: AppColors.white),
              ),
            ],
          ),
          builder: (c, appProvider, child) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(
              left: appProvider.isRTL ? 0 : getOffset(screenSize.width),
              right: appProvider.isRTL ? getOffset(screenSize.width) : 0,
              bottom: 5,
            ),
            child: child,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
          padding: EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
          width: infoContainerWidth,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            boxShadow: [const BoxShadow(blurRadius: 7, color: AppColors.shadow)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Slider(
                value: sliderValue,
                onChanged: null,
                divisions: orderStatusTexts.length - 1,
                min: 0,
                max: (orderStatusTexts.length - 1).toDouble(),
              ),
              Row(
                children: List.generate(
                  orderStatusTexts.length,
                  (i) => Expanded(
                    child: Text(
                      Translations.of(context).get(orderStatusTexts[i]),
                      style: AppTextStyles.subtitleXs,
                      textAlign: i == 0
                          ? TextAlign.start
                          : i == orderStatusTexts.length - 1
                              ? TextAlign.end
                              : TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                margin: EdgeInsets.only(top: 40, bottom: 10),
                height: 80,
                width: infoContainerWidth - (screenHorizontalPadding * 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [const BoxShadow(blurRadius: 7, color: AppColors.shadow)],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Container(
                            child: AppIcons.iconMdPrimary(FontAwesomeIcons.solidUser),
                            height: 55.0,
                            width: 55.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                const BoxShadow(color: AppColors.shadow, blurRadius: 4),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('Lara')
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: AppButtons.primarySm(
                        onPressed: () {
                          /*Navigator.of(context, rootNavigator: true).pushNamed(
                            widget.channelIsMarket ? MarketPreviousOrderPage.routeName : FoodPreviousOrderPage.routeName,
                            arguments: widget.order.id,
                          );*/
                        },
                        child: Text(
                          Translations.of(context).get("Details"),
                          style: AppTextStyles.subtitleWhite,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double getOffset(double screenWidth) {
    double sliderDivisionWidth = (screenWidth - (screenHorizontalPadding * 4) - (sliderSideGutter * 2)) / (orderStatusTexts.length - 1);
    return ((sliderValue) * sliderDivisionWidth) + (screenHorizontalPadding * 2) - (sliderIndicatorWidth / 2) + sliderSideGutter;
  }

  Map<String, dynamic> getOrderTrackingSliderData(OrderStatus orderStatus) {
    String preparingIcon = widget.channelIsMarket ? 'assets/images/order-at-the-address-icon.png' : 'assets/images/food-order-preparing-icon.png';
    String deliveredIcon = widget.channelIsMarket ? 'assets/images/order-at-the-address-icon.png' : 'assets/images/food-order-delivered-icon.png';

    switch (orderStatus) {
      case OrderStatus.NEW:
        return {
          'slider_value': 0,
          'icon': preparingIcon,
        };
        break;
      case OrderStatus.PREPARING:
        return {
          'slider_value': 0,
          'icon': preparingIcon,
        };
        break;
      case OrderStatus.WAITING_COURIER:
        return {
          'slider_value': 0,
          'icon': preparingIcon,
        };
        break;
      case OrderStatus.ON_THE_WAY:
        return {
          'slider_value': 1,
          'icon': 'assets/images/order-on-the-way-icon.png',
        };
        break;
      case OrderStatus.AT_THE_ADDRESS:
        return {
          'slider_value': 2,
          'icon': 'assets/images/order-at-the-address-icon.png',
        };
        break;
      case OrderStatus.DELIVERED:
        return {
          'slider_value': 3,
          'icon': deliveredIcon,
        };
        break;
      default:
        return {
          'slider_value': 0,
          'icon': preparingIcon,
        };
    }
  }
}
