import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/order_confirmed_dialog.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/text_field_dialog.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_list_items.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/add_coupon_button.dart';
import 'package:tiptop_v2/UI/widgets/address/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/payment_summary.dart';
import 'package:tiptop_v2/UI/widgets/total_button.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/orders_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class MarketCheckoutPage extends StatefulWidget {
  static const routeName = '/checkout-page';

  @override
  _MarketCheckoutPageState createState() => _MarketCheckoutPageState();
}

class _MarketCheckoutPageState extends State<MarketCheckoutPage> {
  bool _isInit = true;
  bool _isLoadingCreateOrder = false;
  bool _isLoadingOrderSubmit = false;
  bool _isLoadingvalidateMarketCoupon = false;

  CartProvider cartProvider;
  OrdersProvider ordersProvider;
  AppProvider appProvider;
  AddressesProvider addressesProvider;
  HomeProvider homeProvider;
  CouponValidationData couponValidationData;

  final couponCodeNotifier = ValueNotifier<String>(null);
  final paymentSummaryTotalsNotifier = ValueNotifier<List<PaymentSummaryTotal>>(null);
  final selectedPaymentMethodNotifier = ValueNotifier<int>(null);

  CheckoutData checkoutData;
  Order submittedMarketOrder;
  PaymentSummaryTotal grandTotal;

  String notes;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _createOrderAndGetCheckoutData() async {
    setState(() => _isLoadingCreateOrder = true);
    await ordersProvider.createMarketOrderAndGetCheckoutData(appProvider, addressesProvider.selectedAddress.id);
    checkoutData = ordersProvider.checkoutData;
    paymentSummaryTotalsNotifier.value = [
      PaymentSummaryTotal(
        title: "Total",
        rawValue: checkoutData.total.raw,
        value: checkoutData.total.formatted,
      ),
      PaymentSummaryTotal(
        title: "Delivery Fee",
        rawValue: checkoutData.deliveryFee.raw,
        value: checkoutData.deliveryFee.raw == 0 ? Translations.of(context).get("Free") : checkoutData.deliveryFee.formatted,
      ),
      PaymentSummaryTotal(
        title: "Grand Total",
        rawValue: checkoutData.grandTotal.raw,
        value: checkoutData.grandTotal.formatted,
        isGrandTotal: true,
      ),
    ];
    grandTotal = paymentSummaryTotalsNotifier.value.firstWhere((total) => total.isGrandTotal, orElse: () => null);
    selectedPaymentMethodNotifier.value = checkoutData.paymentMethods[0].id;
    setState(() => _isLoadingCreateOrder = false);
  }

  Future<void> _validateMarketCouponCode(String _couponCode) async {
    setState(() => _isLoadingvalidateMarketCoupon = true);
    try {
      final responseData = await ordersProvider.validateMarketCoupon(
        appProvider: appProvider,
        cartProvider: cartProvider,
        couponCode: _couponCode,
      );
      if (responseData == 401) {
        setState(() => _isLoadingvalidateMarketCoupon = false);
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
      }
      couponValidationData = ordersProvider.couponValidationData;
      couponCodeNotifier.value = _couponCode;
      paymentSummaryTotalsNotifier.value = [
        PaymentSummaryTotal(
          title: "Total Before Discount",
          rawValue: couponValidationData.totalBefore.raw,
          value: couponValidationData.totalBefore.formatted,
          isDiscounted: true,
        ),
        PaymentSummaryTotal(
          title: "You Saved",
          rawValue: couponValidationData.discountedAmount.raw,
          value: couponValidationData.discountedAmount.formatted,
          isSavedAmount: true,
        ),
        PaymentSummaryTotal(
          title: "Total After Discount",
          rawValue: couponValidationData.totalAfter.raw,
          value: couponValidationData.totalAfter.formatted,
        ),
        PaymentSummaryTotal(
          title: "Delivery Fee",
          rawValue: couponValidationData.deliveryFee.raw,
          value: couponValidationData.deliveryFee.raw == 0 ? Translations.of(context).get("Free") : couponValidationData.deliveryFee.formatted,
        ),
        PaymentSummaryTotal(
          title: "Grand Total",
          rawValue: couponValidationData.grandTotal.raw,
          value: couponValidationData.grandTotal.formatted,
          isGrandTotal: true,
        ),
      ];
      showToast(msg: Translations.of(context).get("Successfully validated coupon code!"));
      setState(() => _isLoadingvalidateMarketCoupon = false);
    } on HttpException catch (error) {
      if (error.errors != null && error.errors.length > 0) {
        appAlert(
          context: context,
          title: Translations.of(context).get("Please make sure the following is corrected"),
          description: error.getErrorsAsString(),
        ).show();
      }
      showToast(msg: Translations.of(context).get("Coupon Validation Failed"));
      setState(() => _isLoadingvalidateMarketCoupon = false);
      couponCodeNotifier.value = null;
      throw error;
    } catch (e) {
      couponCodeNotifier.value = null;
      showToast(msg: Translations.of(context).get("Coupon Validation Failed"));
      setState(() => _isLoadingvalidateMarketCoupon = false);
      throw e;
    }
  }

  EventTracking eventTracking = EventTracking.getActions();
  Cart cart;
  List<int> cartProductIds;
  List<String> cartProductNames;
  Map<String, dynamic> commonEventsParams = {};

  void setCommonEventsParams() {
    cart = cartProvider.marketCart;
    cartProductIds = cart.cartProducts.map((cartProduct) => cartProduct.product.id).toList();
    cartProductNames = cart.cartProducts.map((cartProduct) => cartProduct.product.englishTitle).toList();

    commonEventsParams = {
      'cart_product_count': cart.productsCount,
      'cart_total': cart.total.raw,
      'cart_product_ids': cartProductIds,
      'cart_product_names': cartProductNames,
      //Todo: fill the next 2 params after getting them from product show endpoint
      'cart_product_categories': '',
      'cart_product_parent_categories': '',
      'cart_grand_total': grandTotal.rawValue,
    };
  }

  Future<void> trackViewCheckoutEvent() async {
    if (cart == null) {
      print('Tracking failed! No cart!');
      return;
    }

    await eventTracking.trackEvent(TrackingEvent.VIEW_CHECKOUT, commonEventsParams);
  }

  Future<void> trackCompletePurchaseEvent() async {
    if (submittedMarketOrder == null) {
      print('No submitted order!!');
      return;
    }
    Map<String, dynamic> eventParams = commonEventsParams;

    eventParams.addAll({
      'delivery_fee': couponCodeNotifier.value == null ? checkoutData.deliveryFee.raw : couponValidationData.deliveryFee.raw,
      'order_id': submittedMarketOrder.id,
      'coupon_used': couponCodeNotifier.value != null,
    });
    if (couponCodeNotifier.value != null) {
      eventParams.addAll({
        'coupon_code': couponCodeNotifier.value,
        'coupon_value': couponValidationData.discountedAmount.raw,
      });
    }
    await eventTracking.trackEvent(TrackingEvent.COMPLETE_PURCHASE, eventParams);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      cartProvider = Provider.of<CartProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      ordersProvider = Provider.of<OrdersProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      _createOrderAndGetCheckoutData().then((_) {
        setCommonEventsParams();
        trackViewCheckoutEvent();
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasOverlayLoader: _isLoadingOrderSubmit,
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: _isLoadingCreateOrder || _isLoadingvalidateMarketCoupon
          ? const AppLoader()
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  AddressSelectButton(isDisabled: true),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(screenHorizontalPadding),
                            color: AppColors.white,
                            child: AppTextField(
                              labelText: 'Notes',
                              maxLines: 3,
                              hintText: Translations.of(context).get("You can write your order notes here"),
                              fit: true,
                              onSaved: (value) {
                                notes = value;
                              },
                            ),
                          ),
                          SectionTitle('Payment Methods'),
                          ValueListenableBuilder(
                            valueListenable: selectedPaymentMethodNotifier,
                            builder: (c, selectedPaymentMethodId, _) => RadioListItems(
                              items: checkoutData.paymentMethods
                                  .map((method) => {
                                        'id': method.id,
                                        'title': method.title,
                                        'logo': method.logo,
                                      })
                                  .toList(),
                              selectedId: selectedPaymentMethodId,
                              action: (value) => selectedPaymentMethodNotifier.value = value,
                            ),
                          ),
                          SectionTitle('Promotions'),
                          ValueListenableBuilder(
                            valueListenable: couponCodeNotifier,
                            builder: (c, couponCode, _) {
                              return AddCouponButton(
                                couponCode: couponCode,
                                enterCouponAction: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => TextFieldDialog(
                                      textFieldHint: "Enter Promo Code",
                                    ),
                                  ).then((_couponCode) {
                                    if (_couponCode is String && _couponCode.isNotEmpty) {
                                      _validateMarketCouponCode(_couponCode);
                                    }
                                  });
                                },
                                deleteAction: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ConfirmAlertDialog(
                                      title: 'Are you sure you want to delete the coupon?',
                                    ),
                                  ).then((response) {
                                    if (response != null && response) {
                                      couponCodeNotifier.value = null;
                                      _createOrderAndGetCheckoutData();
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          SectionTitle('Payment Summary'),
                          ValueListenableBuilder(
                            valueListenable: paymentSummaryTotalsNotifier,
                            builder: (c, paymentSummaryTotals, _) => PaymentSummary(
                              totals: paymentSummaryTotals,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: paymentSummaryTotalsNotifier,
                    builder: (c, List<PaymentSummaryTotal> paymentSummaryTotals, _) {
                      grandTotal = paymentSummaryTotals.firstWhere((grandTotal) => grandTotal.isGrandTotal, orElse: () => null);
                      return TotalButton(
                        isRTL: appProvider.isRTL,
                        total: grandTotal != null ? grandTotal.value : cartProvider.marketCart.total.formatted,
                        isLoading: cartProvider.isLoadingAdjustCartQuantityRequest,
                        child: Text(Translations.of(context).get("Order Now")),
                        onTap: _submitOrder,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _submitOrder() async {
    _formKey.currentState.save();
    try {
      setState(() => _isLoadingOrderSubmit = true);
      await ordersProvider.submitMarketOrder(
        appProvider,
        cartProvider,
        addressesProvider,
        paymentMethodId: selectedPaymentMethodNotifier.value,
        notes: notes,
        couponCode: couponCodeNotifier.value,
      );
      submittedMarketOrder = ordersProvider.submittedMarketOrder;
      setState(() => _isLoadingOrderSubmit = false);
      if (submittedMarketOrder == null) {
        throw 'No order returned!';
      }
      await trackCompletePurchaseEvent();
      showDialog(
        context: context,
        builder: (context) => OrderConfirmedDialog(),
      ).then((_) {
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(AppWrapper.routeName, (Route<dynamic> route) => false);
      });
    } catch (e) {
      setState(() => _isLoadingOrderSubmit = false);
      showToast(msg: Translations.of(context).get("An error occurred while submitting your order!"));
      throw e;
    }
  }
}
