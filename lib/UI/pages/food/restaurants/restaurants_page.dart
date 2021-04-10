import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurants_index.dart';

class RestaurantsPage extends StatelessWidget {
  static const routeName = '/restaurants';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        child: RestaurantsIndex(),
      ),
    );
  }
}
