import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/address_icon.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class PreviousOrderItem extends StatelessWidget {
  final Order order;
  final bool isRTL;

  PreviousOrderItem({
    @required this.order,
    @required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: () {
          //Todo: show order show page
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AddressIcon(
                          isRTL: isRTL,
                          icon: 'assets/images/address-home-icon.png',
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.completedAt.formatted,
                              style: AppTextStyles.body50,
                            ),
                            SizedBox(height: 5),
                            Text('Home')
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 33,
                      width: 110,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(blurRadius: 6, color: AppColors.shadowDark)],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 33,
                            width: 30,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isRTL ? 0 : 8),
                                bottomLeft: Radius.circular(isRTL ? 0 : 8),
                                topRight: Radius.circular(isRTL ? 8 : 0),
                                bottomRight: Radius.circular(isRTL ? 8 : 0),
                              ),
                            ),
                            child: AppIcon.icon(LineAwesomeIcons.shopping_cart),
                          ),
                          Expanded(
                            child: Html(
                              data: """${order.grandTotal.formatted}""",
                              shrinkWrap: true,
                              style: {
                                "body": Style(
                                  color: AppColors.white,
                                  fontSize: order.grandTotal.formatted.length > 7 ? FontSize(10) : FontSize(12),
                                  lineHeight: LineHeight(1),
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 10),
              AppIcon.iconSecondary(isRTL ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight),
            ],
          ),
        ),
      ),
    );
  }
}
