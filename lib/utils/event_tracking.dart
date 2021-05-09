import 'dart:async';
import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:uni_links/uni_links.dart';

class EventTracking {
  static final EventTracking _instance = EventTracking();

  static EventTracking getActions() {
    return _instance;
  }

  final facebookAppEvents = FacebookAppEvents();
  Mixpanel mixpanel;

  Future<void> initEventTracking(AppProvider appProvider) async {
    await initFacebookAppEvents();
    await initMixpanel();
    await initAdjust();
    await initUniLinks(appProvider);
  }

  Future<void> initFacebookAppEvents() async {
    print('Initiating facebook app events...');
    await facebookAppEvents.setAdvertiserTracking(enabled: true);
  }

  Future<void> initMixpanel() async {
    try {
      print('Initiating MixPanel...');
      mixpanel = await Mixpanel.init("6d5313743174278f57c324f5aadcc75c");
      if (AppProvider.userPhoneNumber != null) {
        mixpanel.identify(AppProvider.userPhoneNumber);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> initAdjust() async {
    try {
      AdjustConfig config = new AdjustConfig('yajo2k3wjp4w', AdjustEnvironment.production);
      config.logLevel = AdjustLogLevel.suppress;
      // config.isDeviceKnown = false;
      // config.defaultTracker = 'abc123';
      // config.processName = 'com.adjust.examples';
      // config.sendInBackground = true;
      // config.eventBufferingEnabled = true;
      // config.delayStart = 6.0;
      // config.setAppSecret(1000, 1, 2, 3, 4);
      // config.externalDeviceId = 'random-external-device-id';
      // config.deactivateSKAdNetworkHandling();

      config.attributionCallback = (AdjustAttribution attributionChangedData) {
        print('[Adjust]: Attribution changed!');

        if (attributionChangedData.trackerToken != null) {
          print('[Adjust]: Tracker token: ' + attributionChangedData.trackerToken);
        }
        if (attributionChangedData.trackerName != null) {
          print('[Adjust]: Tracker name: ' + attributionChangedData.trackerName);
        }
        if (attributionChangedData.campaign != null) {
          print('[Adjust]: Campaign: ' + attributionChangedData.campaign);
        }
        if (attributionChangedData.network != null) {
          print('[Adjust]: Network: ' + attributionChangedData.network);
        }
        if (attributionChangedData.creative != null) {
          print('[Adjust]: Creative: ' + attributionChangedData.creative);
        }
        if (attributionChangedData.adgroup != null) {
          print('[Adjust]: Adgroup: ' + attributionChangedData.adgroup);
        }
        if (attributionChangedData.clickLabel != null) {
          print('[Adjust]: Click label: ' + attributionChangedData.clickLabel);
        }
        if (attributionChangedData.adid != null) {
          print('[Adjust]: Adid: ' + attributionChangedData.adid);
        }
      };

      config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessData) {
        print('[Adjust]: Session tracking success!');

        if (sessionSuccessData.message != null) {
          print('[Adjust]: Message: ' + sessionSuccessData.message);
        }
        if (sessionSuccessData.timestamp != null) {
          print('[Adjust]: Timestamp: ' + sessionSuccessData.timestamp);
        }
        if (sessionSuccessData.adid != null) {
          print('[Adjust]: Adid: ' + sessionSuccessData.adid);
        }
        if (sessionSuccessData.jsonResponse != null) {
          print('[Adjust]: JSON response: ' + sessionSuccessData.jsonResponse);
        }
      };

      config.sessionFailureCallback = (AdjustSessionFailure sessionFailureData) {
        print('[Adjust]: Session tracking failure!');

        if (sessionFailureData.message != null) {
          print('[Adjust]: Message: ' + sessionFailureData.message);
        }
        if (sessionFailureData.timestamp != null) {
          print('[Adjust]: Timestamp: ' + sessionFailureData.timestamp);
        }
        if (sessionFailureData.adid != null) {
          print('[Adjust]: Adid: ' + sessionFailureData.adid);
        }
        if (sessionFailureData.willRetry != null) {
          print('[Adjust]: Will retry: ' + sessionFailureData.willRetry.toString());
        }
        if (sessionFailureData.jsonResponse != null) {
          print('[Adjust]: JSON response: ' + sessionFailureData.jsonResponse);
        }
      };

      config.eventSuccessCallback = (AdjustEventSuccess eventSuccessData) {
        print('[Adjust]: Event tracking success!');

        if (eventSuccessData.eventToken != null) {
          print('[Adjust]: Event token: ' + eventSuccessData.eventToken);
        }
        if (eventSuccessData.message != null) {
          print('[Adjust]: Message: ' + eventSuccessData.message);
        }
        if (eventSuccessData.timestamp != null) {
          print('[Adjust]: Timestamp: ' + eventSuccessData.timestamp);
        }
        if (eventSuccessData.adid != null) {
          print('[Adjust]: Adid: ' + eventSuccessData.adid);
        }
        if (eventSuccessData.callbackId != null) {
          print('[Adjust]: Callback ID: ' + eventSuccessData.callbackId);
        }
        if (eventSuccessData.jsonResponse != null) {
          print('[Adjust]: JSON response: ' + eventSuccessData.jsonResponse);
        }
      };

      config.eventFailureCallback = (AdjustEventFailure eventFailureData) {
        print('[Adjust]: Event tracking failure!');

        if (eventFailureData.eventToken != null) {
          print('[Adjust]: Event token: ' + eventFailureData.eventToken);
        }
        if (eventFailureData.message != null) {
          print('[Adjust]: Message: ' + eventFailureData.message);
        }
        if (eventFailureData.timestamp != null) {
          print('[Adjust]: Timestamp: ' + eventFailureData.timestamp);
        }
        if (eventFailureData.adid != null) {
          print('[Adjust]: Adid: ' + eventFailureData.adid);
        }
        if (eventFailureData.callbackId != null) {
          print('[Adjust]: Callback ID: ' + eventFailureData.callbackId);
        }
        if (eventFailureData.willRetry != null) {
          print('[Adjust]: Will retry: ' + eventFailureData.willRetry.toString());
        }
        if (eventFailureData.jsonResponse != null) {
          print('[Adjust]: JSON response: ' + eventFailureData.jsonResponse);
        }
      };

      config.deferredDeeplinkCallback = (String uri) {
        print('[Adjust][Adjust][Adjust][Adjust][Adjust][Adjust]: Received deferred deeplink: ' + uri);
      };
/*
      // Add session callback parameters.
      Adjust.addSessionCallbackParameter('scp_foo_1', 'scp_bar');
      Adjust.addSessionCallbackParameter('scp_foo_2', 'scp_value');

      // Add session Partner parameters.
      Adjust.addSessionPartnerParameter('spp_foo_1', 'spp_bar');
      Adjust.addSessionPartnerParameter('spp_foo_2', 'spp_value');

      // Remove session callback parameters.
      Adjust.removeSessionCallbackParameter('scp_foo_1');
      Adjust.removeSessionPartnerParameter('spp_foo_1');

      // Clear all session callback parameters.
      Adjust.resetSessionCallbackParameters();

      // Clear all session partner parameters.
      Adjust.resetSessionPartnerParameters();*/

      // Ask for tracking consent.
      Adjust.requestTrackingAuthorizationWithCompletionHandler().then((status) {
        print('[Adjust]: Authorization status update!');
        switch (status) {
          case 0:
            print('[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusNotDetermined');
            break;
          case 1:
            print('[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusRestricted');
            break;
          case 2:
            print('[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusDenied');
            break;
          case 3:
            print('[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusAuthorized');
            break;
        }
      });

      // Start SDK.
      Adjust.start(config);
    } catch (e) {
      print("Error init Adjust @event_tracking");
      throw e;
    }
  }

  Future<void> initUniLinks(AppProvider appProvider) async {
    // Uri parsing may fail, so we use a try/catch FormatException.
    try {
      final initialUri = await getInitialUri();
      // Use the uri and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      if (initialUri != null) {
        print("Got a deeeeep deep link initialUri 😇🍑:");
        print(initialUri);
        appProvider.setInitialUri(initialUri);
      }
    } on FormatException {
      // Handle exception by warning the user their action did not succeed
      // return?
      print("Error while formatting an incoming deep link @event_tracking");
    }
  }

  Future<void> trackEvent(TrackingEvent trackingEvent, Map<String, dynamic> params) async {
    String eventName = trackingEventsValues.reverse[trackingEvent];
    print('Tracking event ($eventName): $params');

    //MixPanel Event Tracking
    mixpanel.track(eventName, properties: params);

    //Adjust Event Tracking
    String adjustEventToken = adjustTrackingEventsTokens.reverse[trackingEvent];
    AdjustEvent adjustEvent = new AdjustEvent(adjustEventToken);
    params.forEach((key, value) {
      String paramValue = value is List<String> || value is List<int> ? json.encode(value) : value.toString();
      adjustEvent.addCallbackParameter(key, paramValue);
    });
    Adjust.trackEvent(adjustEvent);

    //Facebook Event Tracking
    Map<String, dynamic> facebookEventParams = {};
    params.forEach((key, value) {
      if (value != null) {
        facebookEventParams[key] = value is List<String> || value is List<int> ? json.encode(value) : value;
      }
    });
    await facebookAppEvents.logEvent(
      name: eventName,
      parameters: facebookEventParams,
    );
  }
}
