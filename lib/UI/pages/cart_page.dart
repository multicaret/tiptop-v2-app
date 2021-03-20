import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Text('Cart Page'),
      ),
    );
  }
}
