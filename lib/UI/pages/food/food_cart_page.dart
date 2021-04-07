import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';

class FoodCartPage extends StatelessWidget {
  static const routeName = '/food-cart';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(child: Text('Food Cart')),
    );
  }
}
