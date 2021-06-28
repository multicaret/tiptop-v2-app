import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_cahched_network_image.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/address/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/market/products/market_product_list_item.dart';
import 'package:tiptop_v2/UI/widgets/order_info.dart';
import 'package:tiptop_v2/UI/widgets/order_rating_button.dart';
import 'package:tiptop_v2/UI/widgets/payment_summary.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/orders_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'market_order_rating_page.dart';

class MarketPreviousOrderPage extends StatefulWidget {
  static const routeName = '/market-previous-order';

  @override
  _MarketPreviousOrderPageState createState() => _MarketPreviousOrderPageState();
}

class _MarketPreviousOrderPageState extends State<MarketPreviousOrderPage> {
  bool _isInit = true;
  bool _isLoadingOrderRequest = false;

  bool hasCoupon = false;
  OrdersProvider ordersProvider;
  AppProvider appProvider;
  int orderId;
  Order order;
  List<PaymentSummaryTotal> totals = [];
  bool shouldNavigateToOrderRating = false;

  Future<void> _fetchAndSetPreviousOrder() async {
    setState(() => _isLoadingOrderRequest = true);
    await ordersProvider.fetchAndSetPreviousOrder(appProvider, orderId);
    order = ordersProvider.order;
    setState(() => _isLoadingOrderRequest = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      orderId = data["order_id"];
      shouldNavigateToOrderRating = data["should_navigate_to_rating"] ?? false;

      appProvider = Provider.of<AppProvider>(context);
      ordersProvider = Provider.of<OrdersProvider>(context);
      print('orderId: $orderId');
      _fetchAndSetPreviousOrder().then((_) {
        if (shouldNavigateToOrderRating && order != null) {
          Navigator.of(context, rootNavigator: true).pushNamed(
            MarketOrderRatingPage.routeName,
            arguments: {'order': order},
          ).then((response) {
            if (response != null && response) {
              _fetchAndSetPreviousOrder();
            }
          });
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void setTotals() {
    hasCoupon = order.couponDiscountAmount != null && order.couponDiscountAmount.raw != 0;
    totals = [
      PaymentSummaryTotal(
        title: hasCoupon ? "Total Before Discount" : "Total",
        value: order.cart == null ? order.grandTotal.formatted : order.cart.total.formatted,
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
        value: order.deliveryFee.raw == 0 ? Translations.of(context).get("Free") : order.deliveryFee.formatted,
      ),
      PaymentSummaryTotal(
        title: "Grand Total",
        value: order.grandTotal.formatted,
        isGrandTotal: true,
      ),
    ];
    totals.addAll(lastTotals);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoadingOrderRequest && order != null) {
      order = ordersProvider.order;
      setTotals();
    }

    return AppScaffold(
      hasOverlayLoader: ordersProvider.isLoadingDeleteOrderRequest,
      appBar: AppBar(
        title: Text(Translations.of(context).get("Order Details")),
      ),
      body: _isLoadingOrderRequest
          ? AppLoader()
          : Column(
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
                  child: RefreshIndicator(
                    onRefresh: _fetchAndSetPreviousOrder,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          OrderInfo(order: order),
                          if (order.status == OrderStatus.DELIVERED &&
                              !(order.orderRating.branchHasBeenRated && order.orderRating.branchRatingValue == 0))
                            OrderRatingButton(
                              order: order,
                              onTap: order.orderRating.branchHasBeenRated
                                  ? null
                                  : () {
                                      Navigator.of(context, rootNavigator: true).pushNamed(
                                        MarketOrderRatingPage.routeName,
                                        arguments: {'order': order},
                                      ).then((response) {
                                        if (response != null && response) {
                                          _fetchAndSetPreviousOrder();
                                        }
                                      });
                                    },
                              isRTL: appProvider.isRTL,
                            ),
                          if (order.cart != null) SectionTitle('Cart', suffix: ' (${order.cart.productsCount})'),
                          if (order.cart != null)
                            ...List.generate(
                              order.cart.cartProducts.length,
                              (i) => MarketProductListItem(
                                quantity: order.cart.cartProducts[i].quantity,
                                product: order.cart.cartProducts[i].product,
                                disabled: true,
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
                                  Text(Translations.of(context).get("Coupon Code")),
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
                                AppCachedNetworkImage(
                                  imageUrl: order.paymentMethod.logo,
                                  width: 30,
                                  loaderWidget: SpinKitDoubleBounce(
                                    color: AppColors.secondary,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SectionTitle('Payment Summary'),
                          PaymentSummary(totals: totals),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
