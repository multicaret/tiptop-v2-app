import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/profile/previous_order_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/previous_order_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/orders_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';

class PreviousOrdersPage extends StatefulWidget {
  static const routeName = '/previous-orders';

  @override
  _PreviousOrdersPageState createState() => _PreviousOrdersPageState();
}

class _PreviousOrdersPageState extends State<PreviousOrdersPage> {
  bool _isInit = true;
  bool _isLoadingPreviousOrders = false;

  OrdersProvider ordersProvider;
  AppProvider appProvider;
  HomeProvider homeProvider;
  List<Order> previousOrders = [];

  Future<void> _fetchAndSetPreviousOrders() async {
    setState(() => _isLoadingPreviousOrders = true);
    final response = await ordersProvider.fetchAndSetPreviousOrders(appProvider, homeProvider);
    if (response == 401) {
      showToast(msg: 'You need to log in first!');
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
    }
    previousOrders = ordersProvider.previousOrders;
    setState(() => _isLoadingPreviousOrders = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      ordersProvider = Provider.of<OrdersProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      _fetchAndSetPreviousOrders();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get('Previous Orders')),
      ),
      body: _isLoadingPreviousOrders
          ? Center(child: AppLoader())
          : previousOrders.length == 0
              //Todo: add no-orders view
              ? Center(child: Text('No previous orders'))
              : RefreshIndicator(
                  onRefresh: _fetchAndSetPreviousOrders,
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: previousOrders.length,
                    itemBuilder: (context, i) => PreviousOrderItem(
                      order: previousOrders[i],
                      isRTL: appProvider.isRTL,
                      action: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(PreviousOrderPage.routeName, arguments: previousOrders[i].id);
                      },
                      dismissAction: () {
                        int orderIdToRemove = previousOrders[i].id;
                        setState(() {
                          previousOrders.removeAt(i);
                        });
                        ordersProvider.deletePreviousOrder(appProvider, orderIdToRemove).then((_) {
                          showToast(msg: 'Successfully Deleted Order From History!');
                          return true;
                        }).catchError((e) {
                          showToast(msg: 'Error deleting order!');
                        });
                      },
                    ),
                  ),
                ),
    );
  }
}
