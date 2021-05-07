import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:tiptop_v2/models/enums.dart';

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
    } catch (e) {
      throw e;
    }
  }

  Future<void> trackEvent(TrackingEvent trackingEvent, Map<String, dynamic> params) async {
    String eventName = trackingEventsValues.reverse[trackingEvent];
    print('Tracking event ($eventName) with params:');
    print(params);

    Map<String, dynamic> facebookEventParams = {};
    params.forEach((key, value) {
      facebookEventParams[key] = value is List<String> || value is List<int> ? json.encode(value) : value;
    });
    //Facebook Event Tracking
    await facebookAppEvents.logEvent(
      name: eventName,
      parameters: facebookEventParams,
    );
    //MixPanel Event Tracking
    mixpanel.track(eventName, properties: params);

    //Adjust Event Tracking
    // AdjustEvent adjustEvent = new AdjustEvent(eventToken);
    // params.forEach((key, value) {
    //   String paramValue = value is List<String> || value is List<int> ? json.encode(value) : value;
    //   adjustEvent.addCallbackParameter(key, paramValue);
    // });
    // Adjust.trackEvent(adjustEvent);
  }
}
