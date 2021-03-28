import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/models/order.dart';

class OrderRatingPage extends StatefulWidget {
  static const routeName = '/order-rating';

  @override
  _OrderRatingPageState createState() => _OrderRatingPageState();
}

class _OrderRatingPageState extends State<OrderRatingPage> {
  bool _isInit = true;
  Order order;

  @override
  void didChangeDependencies() {
    if(_isInit) {
      Map<String, dynamic> data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      order = data["order"];
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(),
          ],
        ),
      )
    );
  }
}
