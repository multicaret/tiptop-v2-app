import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/previous_order_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/orders_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';

import 'food_previous_order_page.dart';

class FoodPreviousOrdersPage extends StatefulWidget {
  static const routeName = '/food-previous-orders';

  @override
  _FoodPreviousOrdersPageState createState() => _FoodPreviousOrdersPageState();
}

class _FoodPreviousOrdersPageState extends State<FoodPreviousOrdersPage> {
  bool _isInit = true;
  bool _isLoadingPreviousOrders = false;

  OrdersProvider ordersProvider;
  AppProvider appProvider;
  List<Order> previousOrders = [];

  Future<void> _fetchAndSetFoodPreviousOrders() async {
    setState(() => _isLoadingPreviousOrders = true);
    final response = await ordersProvider.fetchAndSetFoodPreviousOrders(appProvider);
    if (response == 401) {
      showToast(msg: 'You need to log in first!');
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
    }
    previousOrders = ordersProvider.foodPreviousOrders;
    setState(() => _isLoadingPreviousOrders = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      ordersProvider = Provider.of<OrdersProvider>(context);
      _fetchAndSetFoodPreviousOrders();
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
                  onRefresh: _fetchAndSetFoodPreviousOrders,
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: previousOrders.length,
                    itemBuilder: (context, i) => PreviousOrderItem(
                      order: previousOrders[i],
                      isRTL: appProvider.isRTL,
                      action: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(FoodPreviousOrderPage.routeName, arguments: previousOrders[i].id)
                            .then((shouldRefresh) {
                          print('shouldRefresh');
                          print(shouldRefresh);
                          if (shouldRefresh != null && shouldRefresh == true) {
                            _fetchAndSetFoodPreviousOrders();
                          }
                        });
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
