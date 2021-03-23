import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_text_field.dart';
import 'package:tiptop_v2/UI/widgets/order_button.dart';
import 'package:tiptop_v2/UI/widgets/section_title.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
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

  CartProvider cartProvider;
  AppProvider appProvider;
  HomeProvider homeProvider;
  CheckoutData checkoutData;
  List<Map<String, String>> totals = [];

  Future<void> _createCheckout() async {
    setState(() => _isLoading = true);
    await cartProvider.createCheckout(appProvider, homeProvider);
    checkoutData = cartProvider.checkoutData;
    totals = [
      {
        "title": "Total",
        "value": checkoutData.total.amountFormatted,
      },
      {
        "title": "Delivery Fee",
        "value": checkoutData.deliveryFee.amountFormatted,
      },
      {
        "title": "Grand Total",
        "value": checkoutData.grandTotal.amountFormatted,
      },
    ];
    print(checkoutData.paymentMethods[0].title);
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
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: _isLoading
          ? AppLoader(
              width: 70,
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: AppColors.bg,
                    padding: EdgeInsets.only(bottom: 105),
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
    //Todo: send submit order post request
  }

  int _selectedPaymentMethodIndex = 0;

  List<Widget> _getPaymentMethodsRadioButtons() {
    return List.generate(checkoutData.paymentMethods.length, (i) {
      return InkWell(
        onTap: () {
          setState(() => _selectedPaymentMethodIndex = i);
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
                    value: i,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    groupValue: _selectedPaymentMethodIndex,
                    activeColor: AppColors.secondaryDark,
                    onChanged: (value) {
                      setState(() => _selectedPaymentMethodIndex = value);
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
