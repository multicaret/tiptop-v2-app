import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/profile/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/profile/article_page.dart';
import 'package:tiptop_v2/UI/pages/profile/blog_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_products_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_restaurants_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/utils/helper.dart';

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
  bool hasIdentifiedChannel = requestedAppChannel != null && (requestedAppChannel == AppChannel.MARKET || requestedAppChannel == AppChannel.FOOD);
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
      if (hasIdentifiedChannel && isAuth) {
        print("Open Favorites page: in $requestedAppChannel");
        Navigator.of(context, rootNavigator: true).pushNamed(
          requestedAppChannel == AppChannel.FOOD ? FavoriteRestaurantsPage.routeName : FavoriteMarketProductsPage.routeName,
        );
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
      break;
    case "home_screen_by_channel":
      if (hasIdentifiedChannel) {
        // Todo: Open Home page: using {uriChannel}
        print("Open Home page: using {uriChannel}");
      }
      break;
    case "market_food_category_show":
      if (requestedAppChannel != null && itemId != null && itemParentId != null) {
        // Todo: Open Food Branch scroll to category: using: { uriChannel, itemId, itemParentId}
        if (requestedAppChannel == AppChannel.MARKET) {}
        print("Open Food Branch scroll to category: using: { uriChannel, itemId, itemParentId}");
        // OR
        // Todo: Open Category Market scroll to category: using: { uriChannel, itemId, itemParentId}
        print("Open Category Market scroll to category: using: { uriChannel, itemId, itemParentId}");
      }
      break;
    case "order_rating":
      if (itemId != null) {
        // Todo: Open Order Rating screen: using: {itemId}
        print("Open Order Rating screen: using: {itemId}");
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
        // Todo: Open Order Tracking screen: using: {itemId}
        print("Open Order Tracking screen: using: {itemId}");
      }
      break;
    case "previous_orders":
      if (!isAuth) {
        print('User not authenticated to enter this route');
        showToast(msg: Translations.of(context).get("You Need to Log In First!"));
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
        return;
      }
      if (isAuth && hasIdentifiedChannel) {
        // Todo: Open Previous Orders page: using {uriChannel}
        print("Open Previous Orders page: using {uriChannel}");
      }
      break;
    case "product_show":
      if (itemId != null && hasIdentifiedChannel) {
        // Todo: Open Product Show screen: using {itemId,hasChannel}
        print("Open Product Show screen: using {itemId,hasChannel}");
      }
      break;
  }
}
