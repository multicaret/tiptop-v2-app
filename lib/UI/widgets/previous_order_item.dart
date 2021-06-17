import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/order_item.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class PreviousOrderItem extends StatelessWidget {
  final Order order;
  final Function action;
  final Function dismissAction;
  final bool channelIsFood;

  PreviousOrderItem({
    @required this.order,
    this.action,
    this.dismissAction,
    this.channelIsFood = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: action,
        child: OrderItem(order: order, channelIsFood: channelIsFood),
      ),
    );
  }
}
