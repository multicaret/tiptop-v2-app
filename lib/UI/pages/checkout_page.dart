import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/order_confirmed_dialog.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/text_field_dialog.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_select_items.dart';
import 'package:tiptop_v2/UI/widgets/UI/labeled_icon.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/add_coupon_button.dart';
import 'package:tiptop_v2/UI/widgets/address/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/order_button.dart';
import 'package:tiptop_v2/UI/widgets/payment_summary.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/orders_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class CheckoutPage extends StatefulWidget {
  static const routeName = '/checkout-page';

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isInit = true;
  bool _isLoadingCreateOrder = false;
  bool _isLoadingOrderSubmit = false;
  bool _isLoadingValidateCoupon = false;

  CartProvider cartProvider;
  OrdersProvider ordersProvider;
  AppProvider appProvider;
  AddressesProvider addressesProvider;
  HomeProvider homeProvider;
  CouponValidationResponseData couponValidationResponseData;

  final couponCodeNotifier = ValueNotifier<String>(null);
  final paymentSummaryTotalsNotifier = ValueNotifier<List<PaymentSummaryTotal>>(null);
  final selectedPaymentMethodNotifier = ValueNotifier<int>(null);

  CheckoutData checkoutData;
  Order submittedOrder;

  String notes;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _createOrderAndGetCheckoutData() async {
    setState(() => _isLoadingCreateOrder = true);
    await ordersProvider.createOrderAndGetCheckoutData(appProvider);
    checkoutData = ordersProvider.checkoutData;
    paymentSummaryTotalsNotifier.value = [
      PaymentSummaryTotal(
        title: "Total",
        value: checkoutData.total.formatted,
      ),
      PaymentSummaryTotal(
        title: "Delivery Fee",
        value: checkoutData.deliveryFee.formatted,
      ),
      PaymentSummaryTotal(
        title: "Grand Total",
        value: checkoutData.grandTotal.formatted,
        isGrandTotal: true,
      ),
    ];
    selectedPaymentMethodNotifier.value = checkoutData.paymentMethods[0].id;
    setState(() => _isLoadingCreateOrder = false);
  }

  Future<void> _validateCouponCode(String _couponCode) async {
    setState(() => _isLoadingValidateCoupon = true);
    try {
      final responseData = await ordersProvider.validateCoupon(
        appProvider: appProvider,
        cartProvider: cartProvider,
        couponCode: _couponCode,
      );
      if (responseData == 401) {
        setState(() => _isLoadingValidateCoupon = false);
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
      }
      couponValidationResponseData = ordersProvider.couponValidationResponseData;
      couponCodeNotifier.value = _couponCode;
      paymentSummaryTotalsNotifier.value = [
        PaymentSummaryTotal(
          title: "Total Before Discount",
          value: couponValidationResponseData.totalBefore.formatted,
          isDiscounted: true,
        ),
        PaymentSummaryTotal(
          title: "You Saved",
          value: couponValidationResponseData.discountedAmount.formatted,
          isSavedAmount: true,
        ),
        PaymentSummaryTotal(
          title: "Total After Discount",
          value: couponValidationResponseData.totalAfter.formatted,
        ),
        PaymentSummaryTotal(
          title: "Delivery Fee",
          value: couponValidationResponseData.deliveryFee.formatted,
        ),
        PaymentSummaryTotal(
          title: "Grand Total",
          value: couponValidationResponseData.grandTotal.formatted,
          isGrandTotal: true,
        ),
      ];
      showToast(msg: 'Successfully validated coupon code!');
    } catch (e) {
      showToast(msg: 'Coupon Validation Failed');
    }
    setState(() => _isLoadingValidateCoupon = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      cartProvider = Provider.of<CartProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      ordersProvider = Provider.of<OrdersProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      _createOrderAndGetCheckoutData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuilt checkout page');
    return AppScaffold(
      hasOverlayLoader: _isLoadingOrderSubmit,
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: _isLoadingCreateOrder || _isLoadingValidateCoupon
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
                              hintText: Translations.of(context).get('You can write your order notes here'),
                              fit: true,
                              onSaved: (value) {
                                notes = value;
                              },
                            ),
                          ),
                          SectionTitle('Delivery Options'),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.border)),
                              color: AppColors.white,
                            ),
                            padding: appProvider.isRTL ? EdgeInsets.only(left: 17) : EdgeInsets.only(right: 17),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: 1,
                                  onChanged: (_) {},
                                  activeColor: AppColors.secondary,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12, bottom: 17),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Image(
                                              image: AssetImage('assets/images/tiptop-logo-title-yellow.png'),
                                              width: 60,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(Translations.of(context).get('Delivery')),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            DeliveryOptionsDetails(
                                              homeProvider: homeProvider,
                                              icon: LineAwesomeIcons.hourglass,
                                              iconTitle: 'Time',
                                              branchInfo: '${homeProvider.marketHomeData.branch.tiptopDelivery.minDeliveryMinutes}'
                                                  '-${homeProvider.marketHomeData.branch.tiptopDelivery.maxDeliveryMinutes} min',
                                            ),
                                            const SizedBox(height: 10),
                                            DeliveryOptionsDetails(
                                              homeProvider: homeProvider,
                                              icon: LineAwesomeIcons.truck_moving,
                                              iconTitle: 'Delivery Fee',
                                              branchInfo: homeProvider.marketHomeData.branch.tiptopDelivery.fixedDeliveryFee.formatted,
                                            ),
                                            const SizedBox(height: 10),
                                            DeliveryOptionsDetails(
                                              homeProvider: homeProvider,
                                              icon: LineAwesomeIcons.shopping_basket,
                                              iconTitle: 'Min. Cart',
                                              branchInfo: homeProvider.marketHomeData.branch.tiptopDelivery.minimumOrder.formatted,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SectionTitle('Payment Methods'),
                          ValueListenableBuilder(
                            valueListenable: selectedPaymentMethodNotifier,
                            builder: (c, selectedPaymentMethodId, _) => RadioSelectItems(
                              items: checkoutData.paymentMethods
                                  .map((method) => {
                                        'id': method.id,
                                        'title': method.title,
                                        'logo': method.logo,
                                      })
                                  .toList(),
                              selectedId: selectedPaymentMethodId,
                              action: (value) => selectedPaymentMethodNotifier.value = value,
                              isRTL: appProvider.isRTL,
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
                                      textFieldHint: 'Enter Promo Code',
                                    ),
                                  ).then((_couponCode) {
                                    if (_couponCode is String && _couponCode.isNotEmpty) {
                                      _validateCouponCode(_couponCode);
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
                              isRTL: appProvider.isRTL,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: paymentSummaryTotalsNotifier,
                    builder: (c, List<PaymentSummaryTotal> paymentSummaryTotals, _) {
                      PaymentSummaryTotal total = paymentSummaryTotals.firstWhere((total) => total.isGrandTotal, orElse: () => null);
                      return OrderButton(
                        cartProvider: cartProvider,
                        total: total != null ? total.value : cartProvider.marketCart.total.formatted,
                        isRTL: appProvider.isRTL,
                        buttonText: 'Order Now',
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
      await ordersProvider.submitOrder(
        appProvider,
        cartProvider,
        addressesProvider,
        paymentMethodId: selectedPaymentMethodNotifier.value,
        notes: notes,
        couponCode: couponCodeNotifier.value,
      );
      submittedOrder = ordersProvider.submittedOrder;
      setState(() => _isLoadingOrderSubmit = false);
      showDialog(
        context: context,
        builder: (context) => OrderConfirmedDialog(
          isLargeOrder: submittedOrder.cart.productsCount >= 10,
        ),
      ).then((_) {
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppWrapper.routeName);
      });
    } catch (e) {
      setState(() => _isLoadingOrderSubmit = false);
      showToast(msg: 'An error occurred while submitting your order!');
      throw e;
    }
  }
}

class DeliveryOptionsDetails extends StatelessWidget {
  final HomeProvider homeProvider;
  final IconData icon;
  final String iconTitle;
  final String branchInfo;

  DeliveryOptionsDetails({
    this.homeProvider,
    this.icon,
    this.iconTitle,
    this.branchInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: LabeledIcon(
              isIconLarge: true,
              icon: icon,
              text: Translations.of(context).get(iconTitle),
            )),
        Expanded(
          child: Text(
            branchInfo,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
