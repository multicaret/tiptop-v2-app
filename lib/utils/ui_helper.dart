import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

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
  double deliveryInfoContainerHeight = hasDoubleDelivery ? (restaurantSingleDeliveryInfoHeight * 2) : restaurantSingleDeliveryInfoHeight;
  return restaurantCoverHeight + (listItemVerticalPadding * 2) + deliveryInfoContainerHeight + sliverAppBarSearchBarHeight;
}

double getAddressDetailsFormContainerVisibleHeight(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.6;
}

double getAddressMapBottomMargin(BuildContext context) {
  double addressDetailsFormContainerVisibleHeight = getAddressDetailsFormContainerVisibleHeight(context);
  return addressDetailsFormContainerVisibleHeight - 100;
}