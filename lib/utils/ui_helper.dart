import 'package:flutter/material.dart';

import 'constants.dart';

double getColItemHeight(int colCount, BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  return (screenWidth - (screenHorizontalPadding * 2) - (appGridGutter * (colCount - 1))) / colCount;
}

double cartControlsMargin = 10;

double getCartControlsWidth(BuildContext context, {int colCount = 3}) {
  double colItemHeight = getColItemHeight(colCount, context);
  return colItemHeight - (cartControlsMargin * 2);
}

double getCartControlButtonHeight(BuildContext context, {int colCount = 3}) {
  return getCartControlsWidth(context, colCount: colCount) / 3;
}

double getProductGridItemHeight(BuildContext context) {
  return getColItemHeight(3, context) + getCartControlButtonHeight(context) / 2 + marketProductUnitTitleHeight + (10 * 2) + (14 * 6);
}

double getRestaurantPageExpandedHeaderHeight({bool hasDoubleDelivery = false}) {
  double deliveryInfoContainerHeight = hasDoubleDelivery ? ((restaurantSingleDeliveryInfoHeight * 2) + 10) : restaurantSingleDeliveryInfoHeight;
  return restaurantCoverHeight + (20 * 2) + deliveryInfoContainerHeight + sliverAppBarSearchBarHeight;
}