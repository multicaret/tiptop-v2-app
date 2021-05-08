import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/profile/addresses_page.dart';
import 'package:tiptop_v2/UI/pages/profile/blog_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_products_page.dart';
import 'package:tiptop_v2/UI/pages/profile/favorite_restaurants_page.dart';
import 'package:tiptop_v2/models/enums.dart';

String getMainActionFromUri(Uri uri) {
  String host = uri.host;
  print('host: $host');

  switch (host) {
    case 'app.adjust.com':
      String deeplink1 = uri.queryParameters['deep_link'];
      Uri deeplinkUri = Uri.parse(deeplink1);
      return deeplinkUri.host;
      break;
    case '66dh.adj.st':
      String deeplink2 = uri.queryParameters['deep_link'];
      if (deeplink2 != null) {
        var splitDeeplink = deeplink2.split("//");
        return splitDeeplink.length > 1 ? splitDeeplink[1] : host;
      } else {
        var splitDeeplinkStep1 = uri.toString().split("66dh.adj.st/");
        if (splitDeeplinkStep1.length > 1) {
          var splitDeeplinkStep2 = splitDeeplinkStep1[1].split('?');
          return splitDeeplinkStep2.length > 0 ? splitDeeplinkStep2[0] : host;
        }
      }
      break;
    default:
      return host;
  }
}

void runDeepLinkAction(BuildContext context, Uri uri) {
  print('uri: $uri');

  String mainAction = getMainActionFromUri(uri);
  print('mainAction 💩💩💩💩💩: $mainAction');

  var params = uri.queryParametersAll;
  print('params 💩💩💩💩💩: $params');

  String uriChannel = uri.queryParameters['channel'];
  String itemId = uri.queryParameters['id'];
  String itemParentId = uri.queryParameters['parent_id'];
  // Some Flags
  bool hasId = itemId != null;
  bool hasParentId = itemParentId != null;
  bool hasChannel = uriChannel != null;
  AppChannel requestedAppChannel = appChannelValues.map[uriChannel];
  print('requestedAppChannel');
  print(requestedAppChannel);

  switch (mainAction) {
    case "blog_index":
      Navigator.of(context, rootNavigator: true).pushNamed(BlogPage.routeName);
      break;
    case "blog_show":
      if (hasId) {
        // Todo: Open Blog show page: using {itemId}
        print("Open Blog show page: using {itemId}");
      }
      break;
    case "favorites":
      if (hasChannel) {
        print("Open Favorites page: using {uriChannel}");
        Navigator.of(context, rootNavigator: true)
            .pushNamed(uriChannel == 'food' ? FavoriteRestaurantsPage.routeName : FavoriteMarketProductsPage.routeName);
      }
      break;
    case "addresses":
      print("Open Addresses page");
      Navigator.of(context, rootNavigator: true).pushNamed(AddressesPage.routeName);
      break;
    case "home_screen_by_channel":
      if (hasChannel) {
        // Todo: Open Home page: using {uriChannel}
        print("Open Home page: using {uriChannel}");
      }
      break;
    case "market_food_category_show":
      if (hasChannel && hasId && hasParentId) {
        // Todo: Open Food Branch scroll to category: using: { uriChannel, itemId, itemParentId}
        print("Open Food Branch scroll to category: using: { uriChannel, itemId, itemParentId}");
        // OR
        // Todo: Open Category Market scroll to category: using: { uriChannel, itemId, itemParentId}
        print("Open Category Market scroll to category: using: { uriChannel, itemId, itemParentId}");
      }
      break;
    case "order_rating":
      if (hasId) {
        // Todo: Open Order Rating screen: using: {itemId}
        print("Open Order Rating screen: using: {itemId}");
      }
      break;
    case "order_tracking":
      if (hasId) {
        // Todo: Open Order Tracking screen: using: {itemId}
        print("Open Order Tracking screen: using: {itemId}");
      }
      break;
    case "previous_orders":
      if (hasChannel) {
        // Todo: Open Previous Orders page: using {uriChannel}
        print("Open Previous Orders page: using {uriChannel}");
      }
      break;
    case "product_show":
      if (hasId && hasChannel) {
        // Todo: Open Product Show screen: using {itemId,hasChannel}
        print("Open Product Show screen: using {itemId,hasChannel}");
      }
      break;
  }
}
