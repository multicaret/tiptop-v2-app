import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_order_rating_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/address/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/market/products/market_list_product_item.dart';
import 'package:tiptop_v2/UI/widgets/order_rating_button.dart';
import 'package:tiptop_v2/UI/widgets/payment_summary.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/orders_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FoodPreviousOrderPage extends StatefulWidget {
  static const routeName = '/food-previous-order';

  @override
  _FoodPreviousOrderPageState createState() => _FoodPreviousOrderPageState();
}

class _FoodPreviousOrderPageState extends State<FoodPreviousOrderPage> {
  bool _isInit = true;
  int orderId;
  List<PaymentSummaryTotal> totals = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      orderId = ModalRoute.of(context).settings.arguments as int;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _deleteOrder(AppProvider appProvider, OrdersProvider ordersProvider, int orderId) async {
    final response = await showDialog(
      context: context,
      builder: (context) => ConfirmAlertDialog(
        title: 'Are you sure you want to delete this order from your order history?',
      ),
    );
    if (response != null && response) {
      try {
        await ordersProvider.deletePreviousOrder(appProvider, orderId);
        showToast(msg: 'Successfully Deleted Order From History!');
        Navigator.of(context).pop(true);
      } catch (e) {
        showToast(msg: 'Error deleting order!');
        throw e;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, OrdersProvider>(
      builder: (c, appProvider, ordersProvider, _) {
        Order order = ordersProvider.foodPreviousOrders.firstWhere((order) => order.id == orderId);
        bool hasCoupon = order.couponDiscountAmount != null && order.couponDiscountAmount.raw != 0;
        totals = [
          PaymentSummaryTotal(
            title: hasCoupon ? "Total Before Discount" : "Total",
            value: order.cart.total.formatted,
            isDiscounted: hasCoupon,
          ),
        ];
        if (hasCoupon) {
          final couponTotals = [
            PaymentSummaryTotal(
              title: "You Saved",
              value: order.couponDiscountAmount.formatted,
              isSavedAmount: true,
            ),
            PaymentSummaryTotal(
              title: "Total After Discount",
              value: order.totalAfterCouponDiscount.formatted,
            ),
          ];
          totals.addAll(couponTotals);
        }
        final lastTotals = [
          PaymentSummaryTotal(
            title: "Delivery Fee",
            value: order.deliveryFee.formatted,
          ),
          PaymentSummaryTotal(
            title: "Grand Total",
            value: order.grandTotal.formatted,
            isGrandTotal: true,
          ),
        ];
        totals.addAll(lastTotals);

        return AppScaffold(
          hasOverlayLoader: ordersProvider.isLoadingDeleteOrderRequest,
          appBar: AppBar(
            title: Text(Translations.of(context).get('Order Details')),
            actions: [
              IconButton(
                onPressed: () => _deleteOrder(appProvider, ordersProvider, order.id),
                icon: AppIcons.iconPrimary(FontAwesomeIcons.trashAlt),
              )
            ],
          ),
          body: Column(
            children: [
              AddressSelectButton(
                isDisabled: true,
                hasETA: false,
                forceAddressView: true,
                addressKindIcon: order.address.kind.icon,
                addressKindTitle: order.address.kind.title,
                addressText: order.address.address1,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (order.status == OrderStatus.DELIVERED)
                        OrderRatingButton(
                          order: order,
                          onTap: order.orderRating.branchHasBeenRated
                              ? null
                              : () =>
                                  Navigator.of(context, rootNavigator: true).pushNamed(FoodOrderRatingPage.routeName, arguments: {'order': order}),
                          isRTL: appProvider.isRTL,
                        ),
                      SectionTitle('Cart', suffix: ' (${order.cart.productsCount})'),
                      ...List.generate(
                        order.cart.products.length,
                        (i) => MarketListProductItem(
                          quantity: order.cart.products[i].quantity,
                          product: order.cart.products[i].product,
                          hasControls: false,
                        ),
                      ),
                      if (hasCoupon) SectionTitle('Promotions'),
                      if (hasCoupon)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border(bottom: BorderSide(color: AppColors.border)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Translations.of(context).get('Coupon Code')),
                              Text(
                                order.couponCode,
                                style: AppTextStyles.bodyBold,
                              ),
                            ],
                          ),
                        ),
                      SectionTitle('Payment Method'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: listItemVerticalPaddingSm),
                        color: AppColors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order.paymentMethod.title),
                            CachedNetworkImage(
                              imageUrl: order.paymentMethod.logo,
                              width: 30,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => SpinKitDoubleBounce(
                                color: AppColors.secondary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SectionTitle('Payment Summary'),
                      PaymentSummary(
                        totals: totals,
                        isRTL: appProvider.isRTL,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
