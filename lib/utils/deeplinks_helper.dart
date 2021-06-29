import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/food/food_product_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_previous_order_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/food_previous_orders_page.dart';
import 'package:tiptop_v2/UI/pages/food/order/track_food_order_page.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurant_page.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurants_page.dart';
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

class DeepLinkData {
  Uri uri;
  String mainAction;

  DeepLinkData({
    this.uri,
    this.mainAction,
  });
}

DeepLinkData getDeeplinkUri(Uri originalUri) {
  String deepLink; //full deep link with main action and params
  Uri deepLinkUri = originalUri; //full deep link with main action and params as URI to query params from
  String mainAction; //the main action (e.g. blog_index, favorites, ...) without params

  if (originalUri.host == 'app.adjust.com') {
    deepLink = originalUri.queryParameters['deep_link'];
    deepLinkUri = Uri.parse(deepLink);
    mainAction = deepLinkUri.host;
  } else if (originalUri.host == '66dh.adj.st') {
    deepLink = originalUri.queryParameters['deep_link'];
    if (deepLink != null) {
      var splitDeeplink = deepLink.split("//");
      deepLinkUri = splitDeeplink.length > 1 ? Uri.parse(splitDeeplink[1]) : originalUri;
      mainAction = deepLinkUri.host;
    } else {
      mainAction = originalUri.pathSegments[0];
      deepLinkUri = originalUri;
    }
  } else {
    deepLinkUri = originalUri;
  }

  return DeepLinkData(
    uri: deepLinkUri,
    mainAction: mainAction,
  );
}

void runDeepLinkAction(BuildContext context, Uri uri, bool isAuth, {AppChannel currentChannel}) {
  DeepLinkData deepLinkData = getDeeplinkUri(uri);
  Uri deepLinkUri = deepLinkData.uri;
  String mainAction = deepLinkData.mainAction;

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
          runDeepLinkActionThatNeedsHomeRequest(
            context: context,
            currentChannel: currentChannel,
            requestedAppChannel: requestedAppChannel,
            marketDeepLinkAction: (BuildContext context) {
              pushCupertinoPage(
                context,
                MarketProductsPage(
                  selectedParentCategoryId: int.parse(itemParentId),
                  selectedChildCategoryId: int.parse(itemId),
                  isDeepLink: true,
                ),
              );
            },
          );
          return;
        } else if (requestedAppChannel == AppChannel.FOOD) {
          print("Open Food Branch scroll to category: using: { restaurant id: $itemId, menu categoryId: $itemParentId}");
          runDeepLinkActionThatNeedsHomeRequest(
            context: context,
            currentChannel: currentChannel,
            requestedAppChannel: requestedAppChannel,
            foodDeepLinkAction: (BuildContext context) {
              pushCupertinoPage(
                context,
                RestaurantPage(
                  restaurantId: int.parse(itemParentId),
                  selectedMenuCategoryId: int.parse(itemId),
                ),
              );
            },
          );
          return;
        }
      }
      break;
    case "food_category_show":
      if (itemId != null) {
        runDeepLinkActionThatNeedsHomeRequest(
          context: context,
          currentChannel: currentChannel,
          requestedAppChannel: requestedAppChannel,
          foodDeepLinkAction: (BuildContext context) {
            pushCupertinoPage(
              context,
              RestaurantsPage(
                selectedCategoryId: int.parse(itemId),
              ),
            );
          },
        );
      }
      return;
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
        runDeepLinkActionThatNeedsHomeRequest(
          context: context,
          currentChannel: currentChannel,
          requestedAppChannel: requestedAppChannel,
          foodDeepLinkAction: requestedAppChannel == AppChannel.FOOD
              ? (context) => pushCupertinoPage(
                    context,
                    FoodProductPage(
                      productId: int.parse(itemId),
                    ),
                    rootNavigator: true,
                  )
              : null,
          marketDeepLinkAction: requestedAppChannel == AppChannel.MARKET
              ? (context) => pushCupertinoPage(
                    context,
                    MarketProductPage(
                      productId: int.parse(itemId),
                    ),
                  )
              : null,
        );
        return;
      }
      break;
    default:
      return;
  }
}

AppChannel getDeepLinkChannel(Uri uri) {
  DeepLinkData deepLinkData = getDeeplinkUri(uri);
  Uri deepLinkUri = deepLinkData.uri;

  String uriChannel = deepLinkUri.queryParameters['channel'];
  AppChannel requestedAppChannel = appChannelValues.map[uriChannel];
  return requestedAppChannel;
}

void runDeepLinkActionThatNeedsHomeRequest({
  BuildContext context,
  Function marketDeepLinkAction,
  Function foodDeepLinkAction,
  AppChannel currentChannel,
  AppChannel requestedAppChannel,
}) {
  print("📺 📺 📺 📺 📺 📺");
  print("currentChannel: $currentChannel");
  print("requestedAppChannel: $requestedAppChannel");
  print("📺 📺 📺 📺 📺 📺");
  //If the current channel isn't provided or is not equal to the requested channel,
  if (currentChannel == null || currentChannel != requestedAppChannel) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      CupertinoPageRoute<void>(
        builder: (BuildContext newContext) => AppWrapper(
          targetAppChannel: requestedAppChannel,
          marketDeepLinkAction: marketDeepLinkAction == null
              ? null
              : () {
                  print("Market deeplink action...");
                  marketDeepLinkAction(newContext);
                },
          foodDeepLinkAction: foodDeepLinkAction == null
              ? null
              : () {
                  print("Market deeplink action...");
                  foodDeepLinkAction(newContext);
                },
        ),
      ),
      (Route<dynamic> route) => false,
    );
  } else {
    if (foodDeepLinkAction != null) {
      foodDeepLinkAction(context);
    }
    if (marketDeepLinkAction != null) {
      marketDeepLinkAction(context);
    }
  }
}
