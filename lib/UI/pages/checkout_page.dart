import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/widgets/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_text_field.dart';
import 'package:tiptop_v2/UI/widgets/order_button.dart';
import 'package:tiptop_v2/UI/widgets/order_confirmed_dialog.dart';
import 'package:tiptop_v2/UI/widgets/section_title.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CheckoutPage extends StatefulWidget {
  static const routeName = '/checkout-page';

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isInit = true;
  bool _isLoading = false;
  bool _isLoadingOrderSubmit = false;

  CartProvider cartProvider;
  AppProvider appProvider;
  HomeProvider homeProvider;
  CheckoutData checkoutData;
  List<Map<String, String>> totals = [];
  Order submittedOrder;

  String notes;
  int selectedPaymentMethodId;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _createCheckout() async {
    setState(() => _isLoading = true);
    await cartProvider.createCheckout(appProvider, homeProvider);
    checkoutData = cartProvider.checkoutData;
    totals = [
      {
        "title": "Total",
        "value": checkoutData.total.formatted,
      },
      {
        "title": "Delivery Fee",
        "value": checkoutData.deliveryFee.formatted,
      },
      {
        "title": "Grand Total",
        "value": checkoutData.grandTotal.formatted,
      },
    ];
    selectedPaymentMethodId = checkoutData.paymentMethods[0].id;
    setState(() => _isLoading = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      cartProvider = Provider.of<CartProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      _createCheckout();
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
      body: _isLoading
          ? AppLoader()
          : Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: AppColors.bg,
                    padding: EdgeInsets.only(bottom: 105),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AddressSelectButton(isDisabled: true),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(17),
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
                                  SectionTitle('Payment Methods'),
                                  ..._getPaymentMethodsRadioButtons(),
                                  SectionTitle('Payment Summary'),
                                  ..._getTotalsItems(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                OrderButton(
                  cartProvider: cartProvider,
                  isRTL: appProvider.isRTL,
                  submitAction: _submitOrder,
                ),
              ],
            ),
    );
  }

  Future<void> _submitOrder() async {
    print(selectedPaymentMethodId);
    _formKey.currentState.save();
    print(notes);
    try {
      setState(() => _isLoadingOrderSubmit = true);
      await cartProvider.submitOrder(
        appProvider,
        homeProvider,
        paymentMethodId: selectedPaymentMethodId,
        notes: notes,
      );
      submittedOrder = cartProvider.submittedOrder;
      setState(() => _isLoadingOrderSubmit = false);
      showDialog(
        context: context,
        builder: (context) => OrderConfirmedDialog(),
      ).then((_) {
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppWrapper.routeName);
      });
    } catch (e) {
      setState(() => _isLoadingOrderSubmit = false);
      showToast(msg: 'An error occurred while submitting your order!');
      throw e;
    }
  }

  List<Widget> _getPaymentMethodsRadioButtons() {
    return List.generate(checkoutData.paymentMethods.length, (i) {
      return InkWell(
        onTap: () {
          setState(() => selectedPaymentMethodId = checkoutData.paymentMethods[i].id);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: appProvider.isRTL ? 17 : 7,
            right: appProvider.isRTL ? 7 : 17,
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
            color: AppColors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Radio(
                    value: checkoutData.paymentMethods[i].id,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    groupValue: selectedPaymentMethodId,
                    activeColor: AppColors.secondaryDark,
                    onChanged: (value) {
                      setState(() => selectedPaymentMethodId = value);
                    },
                  ),
                  SizedBox(width: 10),
                  Text(checkoutData.paymentMethods[i].title),
                ],
              ),
              CachedNetworkImage(
                imageUrl: checkoutData.paymentMethods[i].logo,
                width: 40,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _getTotalsItems() {
    return List.generate(totals.length, (i) {
      bool isLastItem = i == totals.length - 1;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: appProvider.isRTL ? 17 : 7,
          left: appProvider.isRTL ? 7 : 17,
        ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Translations.of(context).get(totals[i]['title']),
              style: isLastItem ? AppTextStyles.bodyBoldSecondaryDark : AppTextStyles.body,
            ),
            Expanded(
              child: Html(
                data: """${totals[i]['value']}""",
                style: {
                  "body": Style(
                    textAlign: TextAlign.end,
                    color: isLastItem ? AppColors.secondaryDark : AppColors.primary,
                    fontWeight: isLastItem ? FontWeight.w600 : FontWeight.w400,
                  ),
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
