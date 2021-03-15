import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';

final providers = <SingleChildWidget>[
  ChangeNotifierProvider.value(
    value: HomeProvider(),
  ),
  ChangeNotifierProvider.value(
    value: ProductsProvider(),
  ),
];
