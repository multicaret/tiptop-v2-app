import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

void showToast({@required String msg, Toast length = Toast.LENGTH_SHORT, ToastGravity gravity = ToastGravity.TOP, int timeInSec = 1}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: timeInSec > 1 ? Toast.LENGTH_LONG : length,
      gravity: gravity,
      timeInSecForIosWeb: timeInSec,
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
    return Translations.of(context).get("This field is required");
  }
  return null;
}

String formatDate(BuildContext context, dynamic dateTime, {bool withWeekDay = false}) {
  AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
  DateTime _dateTime = dateTime.runtimeType == DateTime ? dateTime : DateTime.parse(dateTime);
  String formattedDate = withWeekDay
      ? DateFormat.yMMMEd(appProvider.appLocale.languageCode).format(_dateTime)
      : DateFormat.yMMMd(appProvider.appLocale.languageCode).format(_dateTime);
  return formattedDate;
}

String formatTime(BuildContext context, dynamic dateTime) {
  AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
  DateTime _dateTime = dateTime.runtimeType == DateTime ? dateTime : DateTime.parse(dateTime);
  String formattedTime = DateFormat('hh:mm a', appProvider.appLocale.languageCode).format(_dateTime);
  return formattedTime;
}

String priceAndCurrency(dynamic price, Currency currency) {
  String formattedPrice = NumberFormat.decimalPattern('en').format(price);
  String priceAndCurrency = currency.isSymbolAfter ? '$formattedPrice ${currency.symbol}' : '${currency.symbol} $formattedPrice';
  return priceAndCurrency;
}

String currencySymbol(Currency currency) {
  return NumberFormat.simpleCurrency().simpleCurrencySymbol(currency.symbol);
}

bool isCallable(v) => v is Function;

Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'androidId': build.androidId,
    'systemFeatures': build.systemFeatures,
  };
}

Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname': data.utsname.sysname,
    'utsname.nodename': data.utsname.nodename,
    'utsname.release': data.utsname.release,
    'utsname.version': data.utsname.version,
    'utsname.machine': data.utsname.machine,
  };
}

Map<String, dynamic> getMobileApp(PackageInfo deviceData, Map<String, dynamic> platformState) {
  return <String, dynamic>{
    'version': deviceData.version,
    'buildNumber': deviceData.buildNumber,
    'device': {
      'manufacturer': Platform.isAndroid ? platformState['manufacturer'] : platformState['systemName'],
      // Todo: @Suheyl, I've no idea how to get the device name on Android.
      // hoping that 'device' is the write key.
      'name': Platform.isAndroid ? platformState['device'] : platformState['name'],
      'model': platformState['model'],
      'platform': Platform.isAndroid ? 'android' : 'iOS',
      'serial': Platform.isAndroid ? platformState['id'] : platformState['systemVersion'],
      'uuid': Platform.isAndroid ? platformState['androidId'] : platformState['utsname.nodename'],
      'version': Platform.isAndroid ? platformState['version.release'] : platformState['utsname.version'],
    },
  };
}

Alert appAlert({BuildContext context, String title, String description}) {
  return Alert(
    context: context,
    title: title,
    desc: description,
  );
}

String getHttpExceptionMessage(responseData) {
  String exceptionMessage = '';
  if (responseData["status"] != null) {
    exceptionMessage += '\nStatus Code: ${responseData["status"]}';
  }
  if (responseData["message"] != null) {
    exceptionMessage += '\nMessage: ${responseData["message"]}';
  }
  if (responseData["file"] != null) {
    exceptionMessage += '\nFile: ${responseData["file"]}';
  }
  if (responseData["trace"] != null) {
    exceptionMessage += '\nTrace: ${responseData["trace"]}';
  }
  return exceptionMessage.isNotEmpty ? exceptionMessage : 'Unknown Error';
}

List<int> addOrRemoveIdsFromArray({List<int> array, int id, int maxLength, BuildContext context}) {
  if (array != null && array.contains(id)) {
    //Remove Item
    return array.where((_id) => _id != id).toList();
  } else {
    //Check if array length is maximum
    if (maxLength != null && array.length == maxLength) {
      showToast(msg: Translations.of(context).get('You can only add up to {maxLength} items', args: [maxLength.toString()]));
      return array;
    }
    //Add Item
    return <int>[...array, id];
  }
}

bool getUserCanProceed(BranchDelivery delivery, double cartTotal) {
  bool userCanProceed = true;

  if (delivery.isDeliveryEnabled) {
    if (delivery.underMinimumOrderDeliveryFee.raw == 0) {
      //There is a minimum, check total
      userCanProceed = cartTotal < delivery.minimumOrder.raw ? false : true;
    } else {
      userCanProceed = true;
    }
  }
  return userCanProceed;
}

DoubleRawStringFormatted getRestaurantMinimumOrder(Branch restaurant, double cartTotal) {
  bool userCanProceedForTiptop = getUserCanProceed(restaurant.tiptopDelivery, cartTotal);
  bool userCanProceedForRestaurant = getUserCanProceed(restaurant.restaurantDelivery, cartTotal);

  print('userCanProceedForTiptop: $userCanProceedForTiptop');
  print('userCanProceedForRestaurant: $userCanProceedForRestaurant');

  //Both delivery options enabled, take the one with the less minimum
  if (restaurant.tiptopDelivery.isDeliveryEnabled && restaurant.restaurantDelivery.isDeliveryEnabled) {
    return restaurant.tiptopDelivery.minimumOrder.raw < restaurant.restaurantDelivery.minimumOrder.raw
        ? userCanProceedForTiptop
            ? null
            : restaurant.tiptopDelivery.minimumOrder
        : userCanProceedForRestaurant
            ? null
            : restaurant.restaurantDelivery.minimumOrder;
    //Only tiptop delivery
  } else if (restaurant.tiptopDelivery.isDeliveryEnabled && !restaurant.restaurantDelivery.isDeliveryEnabled) {
    return userCanProceedForTiptop ? null : restaurant.tiptopDelivery.minimumOrder;
    //Only restaurant delivery
  } else if (restaurant.restaurantDelivery.isDeliveryEnabled && !restaurant.tiptopDelivery.isDeliveryEnabled) {
    return userCanProceedForRestaurant ? null : restaurant.restaurantDelivery.minimumOrder;
  } else {
    return null;
  }
}

RestaurantDeliveryType initDeliveryTypeSelection(Branch restaurant, double cartTotal) {
  if (restaurant.tiptopDelivery.isDeliveryEnabled && restaurant.restaurantDelivery.isDeliveryEnabled) {
    if (restaurant.tiptopDelivery.underMinimumOrderDeliveryFee.raw == 0 && cartTotal < restaurant.tiptopDelivery.minimumOrder.raw) {
      return RestaurantDeliveryType.RESTAURANT;
    } else if (restaurant.restaurantDelivery.underMinimumOrderDeliveryFee.raw == 0 && cartTotal < restaurant.restaurantDelivery.minimumOrder.raw) {
      return RestaurantDeliveryType.TIPTOP;
    } else {
      return RestaurantDeliveryType.TIPTOP;
    }
  } else if (restaurant.tiptopDelivery.isDeliveryEnabled && !restaurant.restaurantDelivery.isDeliveryEnabled) {
    return RestaurantDeliveryType.TIPTOP;
  } else if (restaurant.restaurantDelivery.isDeliveryEnabled && !restaurant.tiptopDelivery.isDeliveryEnabled) {
    return RestaurantDeliveryType.RESTAURANT;
  }
  return null;
}

DoubleRawStringFormatted calculateDeliveryFee({RestaurantDeliveryType selectedDeliveryType, Branch restaurant, double cartTotal, Currency currency}) {
  double calculatedDeliveryFee = 0.0;
  if (selectedDeliveryType == RestaurantDeliveryType.TIPTOP) {
    calculatedDeliveryFee = cartTotal < restaurant.tiptopDelivery.minimumOrder.raw
        ? restaurant.tiptopDelivery.fixedDeliveryFee.raw + restaurant.tiptopDelivery.underMinimumOrderDeliveryFee.raw
        : restaurant.tiptopDelivery.fixedDeliveryFee.raw;
  } else if (selectedDeliveryType == RestaurantDeliveryType.RESTAURANT) {
    calculatedDeliveryFee = cartTotal < restaurant.restaurantDelivery.minimumOrder.raw
        ? restaurant.restaurantDelivery.fixedDeliveryFee.raw + restaurant.restaurantDelivery.underMinimumOrderDeliveryFee.raw
        : restaurant.restaurantDelivery.fixedDeliveryFee.raw;
  } else {
    calculatedDeliveryFee = 0.0;
  }
  return DoubleRawStringFormatted(
    raw: calculatedDeliveryFee,
    formatted: priceAndCurrency(calculatedDeliveryFee, currency),
  );
}
