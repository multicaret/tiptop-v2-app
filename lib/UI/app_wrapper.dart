import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/food_app.dart';
import 'package:tiptop_v2/UI/market_app.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/one_signal_notifications_provider.dart';
import 'package:tiptop_v2/utils/deeplinks_helper.dart';
import 'package:uni_links/uni_links.dart';

//Widget that sets up the app's OneSignal & DeepLinks listeners
//And returns the requested Food/Market channel
class AppWrapper extends StatefulWidget {
  final AppChannel targetAppChannel;
  final Function marketDeepLinkAction;
  final Function foodDeepLinkAction;

  // static const routeName = '/app-wrapper';

  AppWrapper({
    @required this.targetAppChannel,
    this.marketDeepLinkAction,
    this.foodDeepLinkAction,
  });

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  AppProvider appProvider;
  StreamSubscription _deepLinksSubscription;
  OneSignalNotificationsProvider oneSignalNotificationsProvider;
  StreamSubscription<OSNotificationPayload> _oneSignalListener;

  bool _isInit = true;

  PageController _pageViewController;

  List<Map<String, dynamic>> _pages;

  List<Map<String, dynamic>> _getPages() {
    return [
      {
        'channel': AppChannel.FOOD,
        'page': FoodApp(
          onChannelSwitch: () => _pageViewController.animateToPage(
            1,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          ),
          foodDeepLinkAction: widget.foodDeepLinkAction,
        ),
      },
      {
        'channel': AppChannel.MARKET,
        'page': MarketApp(
          onChannelSwitch: () => _pageViewController.animateToPage(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          ),
          marketDeepLinkAction: widget.marketDeepLinkAction,
        ),
      },
    ];
  }

  @override
  void initState() {
    _pageViewController = PageController(initialPage: widget.targetAppChannel == AppChannel.FOOD ? 0 : 1);
    _pages = _getPages();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      oneSignalNotificationsProvider = Provider.of<OneSignalNotificationsProvider>(context, listen: false);

      _deepLinksSubscription = uriLinkStream.listen((Uri uri) {
        print("Got a deeeeep deep link from subscription: 💩💩💩💩💩💩💩");
        if (uri != null) {
          print('uri: $uri');
          runDeepLinkAction(context, uri, appProvider.isAuth);
        }
        // Use the uri and warn the user, if it is not correct
      }, onError: (err) {
        print('Error while listening to deeplink stream!');
        print('@e $err');
        // Handle exception by warning the user their action did not succeed
      });

      if (oneSignalNotificationsProvider != null && oneSignalNotificationsProvider.getPayload != null) {
        oneSignalNotificationsProvider.initOneSignal();
        if (appProvider.isAuth && appProvider.authUser != null) {
          oneSignalNotificationsProvider.handleSetExternalUserId(appProvider.authUser.id.toString());
        }

        _oneSignalListener = oneSignalNotificationsProvider.getPayload.listen(null);
        _oneSignalListener.onData((event) {
          print("Is opened: ${OneSignalNotificationsProvider.notificationHasOpened}");
          if (event != null && event.additionalData != null && event.additionalData.length > 0) {
            // print(event.additionalData.keys.toString());
            // DeepLink coming from notifications
            if (event.additionalData['deep_link'] != null) {
              runDeepLinkAction(context, Uri.parse(event.additionalData['deep_link']), appProvider.isAuth);
              oneSignalNotificationsProvider.clearPayload();
            }
          }
        });
      }

      if (appProvider.isFirstOpen) {
        appProvider.setIsFirstOpen(false);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _deepLinksSubscription.cancel();
    _oneSignalListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilt app wrapper");
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      child: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageViewController,
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return _pages[index]['page'];
        },
      ),
    );
  }
}
