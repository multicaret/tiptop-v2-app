import 'package:provider/provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';

final providers = [
  ChangeNotifierProvider.value(
    value: HomeProvider(),
  ),
];
