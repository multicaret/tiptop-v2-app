import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rxdart/rxdart.dart';

class OneSignalNotificationsProvider with ChangeNotifier {
  static const String ONE_SIGNAL_APP_ID = "a8feae53-9db1-4b5d-8e9c-b4a8e309bb82";
  static const bool REQUIRE_CONSENT = false;
  static bool notificationHasOpened = false;
  static bool permissionIsAllowedIOS = false;
  OSNotificationPayload payload;
  static void Function() onListen = () => print('onListen');
  static void Function() onCancel = () => print('onCancel');
  BehaviorSubject<OSNotificationPayload> _payloadSubject = BehaviorSubject<OSNotificationPayload>(onListen: onListen, onCancel: onCancel);

  Stream<OSNotificationPayload> get getPayload => _payloadSubject.asBroadcastStream();

  OneSignalNotificationsProvider();

  @override
  void dispose() {
    _payloadSubject.close();
    super.dispose();
  }

  void clearPayload() {
    _payloadSubject.add(null);
  }

  void initOneSignal() async {
    print('=========> init-one-signal');
    OneSignal.shared.setLogLevel(OSLogLevel.none, OSLogLevel.none);
    OneSignal.shared.setRequiresUserPrivacyConsent(REQUIRE_CONSENT); // Todo: set true if important
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

    const osSettings = {OSiOSSettings.autoPrompt: true, OSiOSSettings.inAppLaunchUrl: true};
    OneSignal.shared.init(ONE_SIGNAL_APP_ID, iOSSettings: osSettings);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt.
// We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    if (Platform.isIOS) {
      permissionIsAllowedIOS = await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    }

    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
      OneSignalNotificationsProvider.notificationHasOpened = false;
      _payloadSubject.add(notification.payload);
      print('=========> NOTIFICATION_RECEIVED');

      // print(notification.jsonRepresentation().replaceAll("\\n", "\n"));
      // if (notification.payload.additionalData.containsKey('action')) {
      //   var actionValue = notification.payload.additionalData['action'];
      // }
      // print('====> values' + notification.payload.additionalData.values.toString());
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('=========> NOTIFICATION_OPENED');
      OneSignalNotificationsProvider.notificationHasOpened = true;
      _payloadSubject.add(result.notification.payload);
    });

    print("Getting permissionSubscriptionState");
    OneSignal.shared.getPermissionSubscriptionState().then((status) {
      print("=====> subscribed ${status.subscriptionStatus.subscribed}");
      print("=====> pushToken ${status.subscriptionStatus.pushToken}");
      print("=====> userId ${status.subscriptionStatus.userId}");
      print("=====> hasPrompted ${status.permissionStatus.hasPrompted}");
      print("=====> provisional ${status.permissionStatus.provisional}");
      print("=====> permissionStatus ${status.permissionStatus.status}");
    });

    if (Platform.isIOS) {
      OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
        // will be called whenever the permission changes
        // (ie. user taps Allow on the permission prompt in iOS)
        print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
      });
    } else {
      OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
        print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
      });
    }

    // print("Setting consent to true");
    // OneSignal.shared.consentGranted(true);
  }

  void _handleEmailSubscription() {
    // will be called whenever then user's email subscription changes
    // (ie. OneSignal.setEmail(email) is called and the user gets registered
    OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
      print("EMAIL SUBSCRIPTION STATE CHANGED FROM ${emailChanges.from.subscribed}");
      print("EMAIL SUBSCRIPTION STATE CHANGED TO ${emailChanges.to.subscribed}");
    });
  }

  void _handleInAppMessage() {
    OneSignal.shared.setInAppMessageClickedHandler((OSInAppMessageAction action) {
      print(action.jsonRepresentation().replaceAll("\\n", "\n"));
    });
  }

  Future<Map<String, dynamic>> _handleGetTags() async => await OneSignal.shared.getTags();

  Future<void> _handleSetEmail(emailAddress) async {
    assert(emailAddress != null, "Email address is missing.");
    return await OneSignal.shared.setEmail(email: emailAddress);
  }

  Future<void> _handleLogoutEmail() async => await OneSignal.shared.logoutEmail();

  void _handleSetLocationShared(bool hasShared) {
    OneSignal.shared.setLocationShared(hasShared);
  }

  Future<Map<String, dynamic>> _handleDeleteTag(String key) async {
    assert(key != null, "Key is missing.");
    return await OneSignal.shared.deleteTag(key);
  }

  Future<Map<String, dynamic>> handleSetExternalUserId(externalUserId) async {
    assert(externalUserId != null, "External user id is missing.");
    return await OneSignal.shared.setExternalUserId(externalUserId);
  }

  Future<Map<String, dynamic>> _handleRemoveExternalUserId() => OneSignal.shared.removeExternalUserId();

  Future<Map<String, dynamic>> _handleSendTag(Map<String, dynamic> tags) async {
    assert(tags != null, "Tags is missing.");
    return await OneSignal.shared.sendTags(tags);
  }
}
