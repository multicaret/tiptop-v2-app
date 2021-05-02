import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/order_item.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

import 'UI/dialogs/confirm_alert_dialog.dart';

class PreviousOrderItem extends StatelessWidget {
  final Order order;
  final Function action;
  final Function dismissAction;

  PreviousOrderItem({
    @required this.order,
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
          background: Consumer<AppProvider>(
            builder: (c, appProvider, _) => Container(
              color: Colors.red,
              alignment: appProvider.isRTL ? Alignment.centerLeft : Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
              child: AppIcons.iconMdWhite(FontAwesomeIcons.trashAlt),
            ),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              if (order.status != OrderStatus.DELIVERED && order.status != OrderStatus.CANCELLED) {
                showToast(msg: "You can't delete this order because it's still in progress!");
                return false;
              }
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
          child: OrderItem(order: order),
        ),
      ),
    );
  }
}
