import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/order_item.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';

import 'dialogs/confirm_alert_dialog.dart';

class PreviousOrderItem extends StatelessWidget {
  final Order order;
  final bool isRTL;
  final Function action;
  final Function dismissAction;

  PreviousOrderItem({
    @required this.order,
    @required this.isRTL,
    this.action,
    this.dismissAction,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: action,
        //Todo: implement swipe to delete order
        child: Dismissible(
          key: Key('${order.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: AppIcon.iconMdWhite(FontAwesomeIcons.trashAlt),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              final response = await showDialog(
                context: context,
                builder: (context) => ConfirmAlertDialog(
                  title: 'Are you sure you want to delete this order from your order history?',
                ),
              );
              return response == null ? false : response;
            }
            return false;
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              dismissAction();
            }
          },
          child: OrderItem(isRTL: isRTL, order: order),
        ),
      ),
    );
  }
}
