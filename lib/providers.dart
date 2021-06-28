import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/food_provider.dart';
import 'package:tiptop_v2/providers/market_provider.dart';
import 'package:tiptop_v2/providers/one_signal_notifications_provider.dart';
import 'package:tiptop_v2/providers/orders_provider.dart';
import 'package:tiptop_v2/providers/otp_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/providers/search_provider.dart';

final providers = <SingleChildWidget>[
  ChangeNotifierProvider.value(
    value: FoodProvider(),
  ),
  ChangeNotifierProvider.value(
    value: MarketProvider(),
  ),
  ChangeNotifierProvider.value(
    value: ProductsProvider(),
  ),
  ChangeNotifierProvider.value(
    value: OTPProvider(),
  ),
  ChangeNotifierProvider.value(
    value: CartProvider(),
  ),
  ChangeNotifierProvider.value(
    value: OrdersProvider(),
  ),
  ChangeNotifierProvider.value(
    value: AddressesProvider(),
  ),
  ChangeNotifierProvider.value(
    value: SearchProvider(),
  ),
  ChangeNotifierProvider.value(
    value: RestaurantsProvider(),
  ),
  ChangeNotifierProvider.value(
    value: OneSignalNotificationsProvider(),
  ),
];
