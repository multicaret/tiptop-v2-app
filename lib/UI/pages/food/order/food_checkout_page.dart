import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:tiptop_v2/UI/widgets/food/food_checkout_delivery_options.dart';
import 'package:tiptop_v2/UI/widgets/payment_summary.dart';
import 'package:tiptop_v2/UI/widgets/total_button.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/home.dart';
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

import '../../../app_wrapper.dart';

class FoodCheckoutPage extends StatefulWidget {
  static const routeName = '/food-checkout-page';

  @override
  _FoodCheckoutPageState createState() => _FoodCheckoutPageState();
}

class _FoodCheckoutPageState extends State<FoodCheckoutPage> {
  bool _isInit = true;
  bool _isLoadingCreateOrder = false;
  bool _isLoadingOrderSubmit = false;
  bool _isLoadingvalidateFoodCoupon = false;

  CartProvider cartProvider;
  OrdersProvider ordersProvider;
  AppProvider appProvider;
  AddressesProvider addressesProvider;
  HomeProvider homeProvider;
  CouponValidationData couponValidationData;

  List<PaymentSummaryTotal> paymentSummaryTotals = [];
  PaymentSummaryTotal grandTotal;
  DoubleRawStringFormatted deliveryFee;
  final couponCodeNotifier = ValueNotifier<String>(null);
  final selectedPaymentMethodNotifier = ValueNotifier<int>(null);
  final selectedDeliveryTypeNotifier = ValueNotifier<RestaurantDeliveryType>(null);

  CheckoutData checkoutData;
  Order submittedFoodOrder;
  Branch restaurant;

  String notes;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _createOrderAndGetCheckoutData() async {
    setState(() => _isLoadingCreateOrder = true);
    await ordersProvider.createFoodOrderAndGetCheckoutData(appProvider, addressesProvider.selectedAddress.id);
    checkoutData = ordersProvider.checkoutData;
    deliveryFee = calculateFinalDeliveryFee(
      selectedDeliveryType: selectedDeliveryTypeNotifier.value,
      restaurant: restaurant,
      cartTotal: cartProvider.foodCart.total.raw,
      currency: homeProvider.foodCurrency,
    );
    paymentSummaryTotals = [
      PaymentSummaryTotal(
        title: "Total",
        value: checkoutData.total.formatted,
      ),
      PaymentSummaryTotal(
        title: "Delivery Fee",
        value: deliveryFee.raw == 0 ? Translations.of(context).get("Free") : deliveryFee.formatted,
      ),
      PaymentSummaryTotal(
        title: "Grand Total",
        value: priceAndCurrency(checkoutData.grandTotal.raw + deliveryFee.raw, homeProvider.foodCurrency),
        isGrandTotal: true,
      ),
    ];
    selectedPaymentMethodNotifier.value = checkoutData.paymentMethods[0].id;
    setState(() => _isLoadingCreateOrder = false);
  }

  Future<void> _validateFoodCouponCode(String _couponCode) async {
    setState(() => _isLoadingvalidateFoodCoupon = true);
    if (selectedDeliveryTypeNotifier.value == null) {
      showToast(msg: Translations.of(context).get("Please select delivery option first!"));
      return;
    }
    try {
      await ordersProvider.validateFoodCoupon(
        appProvider: appProvider,
        cartId: cartProvider.foodCart.id,
        selectedAddressId: addressesProvider.selectedAddress.id,
        couponCode: _couponCode,
        deliveryType: selectedDeliveryTypeNotifier.value,
      );
      couponValidationData = ordersProvider.couponValidationData;
      couponCodeNotifier.value = _couponCode;
      paymentSummaryTotals = [
        PaymentSummaryTotal(
          title: "Total Before Discount",
          value: couponValidationData.totalBefore.formatted,
          isDiscounted: true,
        ),
        PaymentSummaryTotal(
          title: "You Saved",
          value: couponValidationData.discountedAmount.formatted,
          isSavedAmount: true,
        ),
        PaymentSummaryTotal(
          title: "Total After Discount",
          value: couponValidationData.totalAfter.formatted,
        ),
        PaymentSummaryTotal(
          title: "Delivery Fee",
          value: couponValidationData.deliveryFee.formatted,
        ),
        PaymentSummaryTotal(
          title: "Grand Total",
          value: couponValidationData.grandTotal.formatted,
          isGrandTotal: true,
        ),
      ];
      showToast(msg: Translations.of(context).get("Successfully validated coupon code!"));
    } catch (e) {
      showToast(msg: Translations.of(context).get("Coupon Validation Failed"));
    }
    setState(() => _isLoadingvalidateFoodCoupon = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Map<String, dynamic> data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      restaurant = data["restaurant"];

      cartProvider = Provider.of<CartProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      ordersProvider = Provider.of<OrdersProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);

      selectedDeliveryTypeNotifier.value = initDeliveryTypeSelection(restaurant, cartProvider.foodCart.total.raw);
      _createOrderAndGetCheckoutData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    grandTotal = paymentSummaryTotals.firstWhere((total) => total.isGrandTotal, orElse: () => null);
    return AppScaffold(
      hasOverlayLoader: _isLoadingOrderSubmit,
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: _isLoadingCreateOrder || _isLoadingvalidateFoodCoupon
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
                              onSaved: (value) => notes = value,
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: selectedDeliveryTypeNotifier,
                            builder: (c, selectedDeliveryType, _) => FoodCheckoutDeliveryOptions(
                              restaurant: restaurant,
                              cartTotal: cartProvider.foodCart.total.raw,
                              selectedDeliveryType: selectedDeliveryType,
                              selectDeliveryType: (_selectedDeliveryType) {
                                if (_selectedDeliveryType != selectedDeliveryType) {
                                  if (couponCodeNotifier.value != null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ConfirmAlertDialog(
                                        title: 'Are you sure you want to change your delivery option? This will delete your coupon',
                                      ),
                                    ).then((response) {
                                      if (response != null && response) {
                                        couponCodeNotifier.value = null;
                                        _createOrderAndGetCheckoutData();
                                      }
                                    });
                                  }
                                  selectedDeliveryTypeNotifier.value = _selectedDeliveryType;
                                  deliveryFee = calculateFinalDeliveryFee(
                                    selectedDeliveryType: _selectedDeliveryType,
                                    restaurant: restaurant,
                                    cartTotal: cartProvider.foodCart.total.raw,
                                    currency: homeProvider.foodCurrency,
                                  );
                                  setState(() {
                                    paymentSummaryTotals = [
                                      PaymentSummaryTotal(
                                        title: "Total",
                                        value: checkoutData.total.formatted,
                                      ),
                                      PaymentSummaryTotal(
                                        title: "Delivery Fee",
                                        value: deliveryFee.raw == 0 ? Translations.of(context).get("Free") : deliveryFee.formatted,
                                      ),
                                      PaymentSummaryTotal(
                                        title: "Grand Total",
                                        value: priceAndCurrency(checkoutData.grandTotal.raw + deliveryFee.raw, homeProvider.foodCurrency),
                                        isGrandTotal: true,
                                      ),
                                    ];
                                  });
                                }
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
                                      _validateFoodCouponCode(_couponCode);
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
                          PaymentSummary(
                            totals: paymentSummaryTotals,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TotalButton(
                    isRTL: appProvider.isRTL,
                    total: grandTotal.value,
                    isLoading: cartProvider.isLoadingAdjustCartQuantityRequest,
                    child: Text(Translations.of(context).get("Order Now")),
                    onTap: _submitFoodOrder,
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _submitFoodOrder() async {
    _formKey.currentState.save();
    try {
      setState(() => _isLoadingOrderSubmit = true);
      await ordersProvider.submitFoodOrder(
        appProvider,
        cartProvider,
        addressesProvider,
        paymentMethodId: selectedPaymentMethodNotifier.value,
        notes: notes,
        couponCode: couponCodeNotifier.value,
        deliveryType: selectedDeliveryTypeNotifier.value,
      );
      submittedFoodOrder = ordersProvider.submittedFoodOrder;
      setState(() => _isLoadingOrderSubmit = false);
      if (submittedFoodOrder == null) {
        throw 'No order returned!';
      }
      showDialog(
        context: context,
        builder: (context) => OrderConfirmedDialog(
          isLargeOrder: submittedFoodOrder.cart.productsCount >= 10,
        ),
      ).then((_) {
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppWrapper.routeName);
      });
    } catch (e) {
      setState(() => _isLoadingOrderSubmit = false);
      showToast(msg: Translations.of(context).get("An error occurred while submitting your order!"));
      throw e;
    }
  }
}
