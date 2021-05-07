import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

class EventTracking {
  static final EventTracking _instance = EventTracking();

  static EventTracking getActions() {
    return _instance;
  }

  final facebookAppEvents = FacebookAppEvents();
  Mixpanel mixpanel;

  Future<void> initEventTracking() async {
    await initFacebookAppEvents();
    await initMixpanel();
  }

  Future<void> initFacebookAppEvents() async {
    print('Initiating facebook app events...');
    await facebookAppEvents.setAdvertiserTracking(enabled: true);
  }

  Future<void> initMixpanel() async {
    try {
      print('Initiating MixPanel...');
      mixpanel = await Mixpanel.init("6d5313743174278f57c324f5aadcc75c");
      if(AppProvider.userPhoneNumber != null) {
        mixpanel.identify(AppProvider.userPhoneNumber);
      }
    } catch (e) {
      throw e;
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
      facebookEventParams[key] = value is List<String> || value is List<int> ? json.encode(value) : value;
    });
    await facebookAppEvents.logEvent(
      name: eventName,
      parameters: facebookEventParams,
    );
  }
}
