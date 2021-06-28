import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/food/food_product_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_previous_order_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/track_food_order_page.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurant_page.dart';
import 'package:tiptop_v2/UI/pages/market/market_product_page.dart';
import 'package:tiptop_v2/UI/pages/market/market_products_page.dart';
import 'package:tiptop_v2/UI/pages/market/order/market_previous_order_page.dart';
import 'package:tiptop_v2/UI/pages/market/order/market_previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/market/order/track_market_order_page.dart';
import 'package:tiptop_v2/UI/pages/profile/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/profile/article_page.dart';
import 'package:tiptop_v2/UI/pages/profile/blog_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_products_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_restaurants_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/utils/helper.dart';

import 'navigator_helper.dart';

void runDeepLinkAction(BuildContext context, Uri uri, bool isAuth) {
  String deepLink; //full deep link with main action and params
  Uri deepLinkUri = uri; //full deep link with main action and params as URI to query params from
  String mainAction; //the main action (e.g. blog_index, favorites, ...) without params

  if (uri.host == 'app.adjust.com') {
    deepLink = uri.queryParameters['deep_link'];
    deepLinkUri = Uri.parse(deepLink);
    mainAction = deepLinkUri.host;
  } else if (uri.host == '66dh.adj.st') {
    deepLink = uri.queryParameters['deep_link'];
    if (deepLink != null) {
      var splitDeeplink = deepLink.split("//");
      deepLinkUri = splitDeeplink.length > 1 ? Uri.parse(splitDeeplink[1]) : uri;
      mainAction = deepLinkUri.host;
    } else {
      mainAction = uri.pathSegments[0];
      deepLinkUri = uri;
    }
  } else {
    deepLinkUri = uri;
  }
  print('👿👿👿👿👿👿👿👿👿👿👿👿👿👿👿👿 DEEPLINK INFO 👿👿👿👿👿👿👿👿👿👿👿👿👿👿👿👿👿');
  print('uri: $uri');
  print('deepLinkUri: $deepLinkUri');
  print('mainAction 💩💩💩💩💩: $mainAction');

  // Uri deepLink = getDeepLinkFromUri(uri);
  // String mainAction = deepLink.host;

  var params = deepLinkUri.queryParametersAll;
  print('params 💩💩💩💩💩: $params');

  String uriChannel = deepLinkUri.queryParameters['channel'];
  String itemId = deepLinkUri.queryParameters['id'];
  String itemParentId = deepLinkUri.queryParameters['parent_id'];

  AppChannel requestedAppChannel = appChannelValues.map[uriChannel];
  // Some Flags
  //Check if channel exists in params and is equal to one of the app's channels
  bool hasValidChannel = requestedAppChannel != null && (requestedAppChannel == AppChannel.MARKET || requestedAppChannel == AppChannel.FOOD);
  print('requestedAppChannel: $requestedAppChannel');
  print('itemId: $itemId');
  print('itemParentId: $itemParentId');
  print('👿👿👿👿👿👿👿👿👿👿👿👿👿👿👿👿 END DEEPLINK INFO 👿👿👿👿👿👿👿👿👿👿👿👿👿👿👿👿👿');

  switch (mainAction) {
    case "blog_index":
      Navigator.of(context, rootNavigator: true).pushNamed(BlogPage.routeName);
      break;
    case "blog_show":
      if (itemId != null) {
        print("Open Blog show page of article with id: $itemId");
        Navigator.of(context, rootNavigator: true).pushNamed(ArticlePage.routeName, arguments: {'article_id': int.parse(itemId)});
      }
      break;
    case "favorites":
      //Check if channel exists in params and is equal to one of the app's channels
      if (!isAuth) {
        print('User not authenticated to enter this route');
        showToast(msg: Translations.of(context).get("You Need to Log In First!"));
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
        return;
      }
      if (hasValidChannel && isAuth) {
        print("Open Favorites page: in $requestedAppChannel");
        Navigator.of(context, rootNavigator: true).pushNamed(
          requestedAppChannel == AppChannel.FOOD ? FavoriteRestaurantsPage.routeName : FavoriteMarketProductsPage.routeName,
        );
        return;
      }
      break;
    case "addresses":
      if (!isAuth) {
        print('User not authenticated to enter this route');
        showToast(msg: Translations.of(context).get("You Need to Log In First!"));
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
        return;
      }
      print("Open Addresses page");
      Navigator.of(context, rootNavigator: true).pushNamed(AddressesPage.routeName);
      return;
      break;
    case "home_screen_by_channel":
      if (hasValidChannel) {
        pushAndRemoveUntilCupertinoPage(
          context,
          AppWrapper(targetAppChannel: requestedAppChannel),
        );
        return;
      }
      break;
    case "market_food_category_show":
      if (hasValidChannel && itemId != null && itemParentId != null) {
        if (requestedAppChannel == AppChannel.MARKET) {
          print("Open Category Market scroll to category: using: { uriChannel, itemId, itemParentId}");
          pushCupertinoPage(
            context,
            MarketProductsPage(
              selectedParentCategoryId: int.parse(itemParentId),
              selectedChildCategoryId: int.parse(itemId),
              isDeepLink: true,
            ),
          );
          return;
        } else if (requestedAppChannel == AppChannel.FOOD) {
          print("Open Food Branch scroll to category: using: { restaurant id: $itemId, menu categoryId: $itemParentId}");
          pushCupertinoPage(
            context,
            RestaurantPage(
              restaurantId: int.parse(itemParentId),
              selectedMenuCategoryId: int.parse(itemId),
            ),
            rootNavigator: true,
          );
          return;
        }
      }
      break;
    case "order_rating":
      if (!isAuth) {
        print('User not authenticated to enter this route');
        showToast(msg: Translations.of(context).get("You Need to Log In First!"));
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
        return;
      }
      if (hasValidChannel && itemId != null) {
        Navigator.of(context, rootNavigator: true).pushNamed(
          requestedAppChannel == AppChannel.MARKET ? MarketPreviousOrderPage.routeName : FoodPreviousOrderPage.routeName,
          arguments: {
            'order_id': int.parse(itemId),
            'should_navigate_to_rating': true,
          },
        );
        return;
      }
      break;
    case "order_tracking":
      if (!isAuth) {
        print('User not authenticated to enter this route');
        showToast(msg: Translations.of(context).get("You Need to Log In First!"));
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
        return;
      }
      if (isAuth && itemId != null) {
        print("Open Order Tracking screen: using order id: $itemId");
        Navigator.of(context, rootNavigator: true).pushNamed(
          requestedAppChannel == AppChannel.FOOD ? TrackFoodOrderPage.routeName : TrackMarketOrderPage.routeName,
          arguments: {
            'order_id': int.parse(itemId),
          },
        );
        return;
      }
      break;
    case "previous_orders":
      if (!isAuth) {
        print('User not authenticated to enter this route');
        showToast(msg: Translations.of(context).get("You Need to Log In First!"));
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
        return;
      }
      if (isAuth && hasValidChannel) {
        print("Open Previous Orders page: using $requestedAppChannel");
        Navigator.of(context, rootNavigator: true).pushNamed(
          requestedAppChannel == AppChannel.MARKET ? MarketPreviousOrdersPage.routeName : FoodPreviousOrdersPage.routeName,
        );
        return;
      }
      break;
    case "product_show":
      if (itemId != null && hasValidChannel) {
        print("Open Product Show screen: using {itemId,hasChannel}");
        pushCupertinoPage(
          context,
          requestedAppChannel == AppChannel.MARKET
              ? MarketProductPage(
                  productId: int.parse(itemId),
                )
              : FoodProductPage(
                  productId: int.parse(itemId),
                ),
          rootNavigator: true,
        );
        return;
      }
      break;
    default:
      return;
  }
}
