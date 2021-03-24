import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/cart_product_item.dart';
import 'package:tiptop_v2/UI/widgets/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/payment_summary.dart';
import 'package:tiptop_v2/UI/widgets/section_title.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/orders_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';

class PreviousOrderPage extends StatefulWidget {
  static const routeName = '/previous-order';

  @override
  _PreviousOrderPageState createState() => _PreviousOrderPageState();
}

class _PreviousOrderPageState extends State<PreviousOrderPage> {
  bool _isInit = true;
  Order order;
  List<Map<String, String>> totals = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      order = ModalRoute.of(context).settings.arguments as Order;
      totals = [
        {
          "title": "Total",
          "value": order.cart.total.formatted,
        },
        {
          "title": "Delivery Fee",
          "value": order.deliveryFee.formatted,
        },
        {
          "title": "Grand Total",
          "value": order.grandTotal.formatted,
        },
      ];
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, OrdersProvider>(
      builder: (c, appProvider, ordersProvider, _) => AppScaffold(
        hasOverlayLoader: ordersProvider.isLoadingDeleteOrderRequest,
        appBar: AppBar(
          title: Text(Translations.of(context).get('Order Details')),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmAlertDialog(
                    title: 'Are you sure you want to delete this order from your order history?',
                  ),
                ).then((response) {
                  if (response) {
                    ordersProvider.deletePreviousOrder(appProvider, order.id).then((_) {
                      showToast(msg: 'Successfully Deleted Order From History!');
                      Navigator.of(context).pop(true);
                    }).catchError((e) {
                      showToast(msg: 'Error deleting order!');
                    });
                  }
                });
              },
              icon: AppIcon.iconPrimary(FontAwesomeIcons.trashAlt),
            )
          ],
        ),
        body: Column(
          children: [
            AddressSelectButton(
              isDisabled: true,
              hasETA: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SectionTitle('Please Rate Your Experience'),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
                      color: AppColors.white,
                      //Todo: add rating stars
                    ),
                    SectionTitle('Cart', suffix: ' (${order.cart.productsCount})'),
                    ...List.generate(
                      order.cart.products.length,
                      (i) => CartProductItem(
                        quantity: order.cart.products[i].quantity,
                        product: order.cart.products[i].product,
                        hasControls: false,
                      ),
                    ),
                    SectionTitle('Payment Summary'),
                    PaymentSummary(
                      totals: totals,
                      isRTL: appProvider.isRTL,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
