import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/address/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/food/track_food_order_map.dart';
import 'package:tiptop_v2/UI/widgets/track_order_info_container.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';

class TrackFoodOrderPage extends StatefulWidget {
  static const routeName = '/track-food-order';

  @override
  _TrackFoodOrderPageState createState() => _TrackFoodOrderPageState();
}

class _TrackFoodOrderPageState extends State<TrackFoodOrderPage> {
  bool _isInit = true;
  HomeProvider homeProvider;
  AppProvider appProvider;
  Order order;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      homeProvider = Provider.of<HomeProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      order = ModalRoute.of(context).settings.arguments as Order;
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AppScaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).get("Track your order")),
      ),
      body: Column(
        children: [
          AddressSelectButton(
            isDisabled: true,
            addressKindIcon: order.address.kind.icon,
            addressKindTitle: order.address.kind.title,
            addressText: order.address.address1,
            forceAddressView: true,
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: screenSize.height,
                  child: TrackFoodOrderMap(restaurant: order.cart.restaurant),
                ),
                Positioned(
                  bottom: 0,
                  child: TrackOrderInfoContainer(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
