import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

void showToast({@required String msg, Toast length = Toast.LENGTH_SHORT, ToastGravity gravity = ToastGravity.BOTTOM}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: length,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black.withOpacity(0.8),
      textColor: AppColors.white,
      fontSize: 16.0);
}

IconData getIconData(data) {
  String name = data['name'];
  int code = int.parse("0x${data['code']}");
  if (name.indexOf('far') == 0) {
    return IconDataRegular(code);
  } else if (name.indexOf('fab') == 0) {
    return IconDataBrands(code);
  }
  return IconDataSolid(code);
}

String formatTimeOfDay(TimeOfDay tod) {
  final now = new DateTime.now();
  final date = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final formattedTod = DateFormat('hh:mm a').format(date);
  return formattedTod;
}

String requiredFieldValidator(BuildContext context, String value) {
  if (value.isEmpty) {
    return Translations.of(context).get('This field is required');
  }
  return null;
}

/*
String priceAndCurrency({dynamic price, Currency currency}) {
  String currencySymbol = NumberFormat.simpleCurrency().simpleCurrencySymbol(currency.code);
  String formattedPrice = NumberFormat.decimalPattern('en').format(price);
  String priceAndCurrency = currency.isSymbolAfter ? '$formattedPrice $currencySymbol' : '$currencySymbol $formattedPrice';
  return priceAndCurrency;
}

String currencySymbol(Currency currency) {
  return NumberFormat.simpleCurrency().simpleCurrencySymbol(currency.code);
}
 */

String formatDate(BuildContext context, dynamic dateTime, {bool withWeekDay = false}) {
  AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
  DateTime _dateTime = dateTime.runtimeType == DateTime ? dateTime : DateTime.parse(dateTime);
  String formattedDate = withWeekDay
      ? DateFormat.yMMMEd(appProvider.appLocal.languageCode).format(_dateTime)
      : DateFormat.yMMMd(appProvider.appLocal.languageCode).format(_dateTime);
  return formattedDate;
}

String formatTime(BuildContext context, dynamic dateTime) {
  AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
  DateTime _dateTime = dateTime.runtimeType == DateTime ? dateTime : DateTime.parse(dateTime);
  String formattedTime = DateFormat('hh:mm a', appProvider.appLocal.languageCode).format(_dateTime);
  return formattedTime;
}

double screenGutter = 17;
double gridGutter = 10;

double getColItemHeight(int colCount, BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  return (screenWidth - (screenGutter * 2) - (gridGutter * (colCount - 1))) / colCount;
}