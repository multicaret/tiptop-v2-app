import 'package:flutter/services.dart';

class DeepLinkPlugin {
  static const MethodChannel _channel = const MethodChannel('multicaret.com/adjust-intent');

  static Future<String> get getUrl async {
    final String version = await _channel.invokeMethod('intentData');
    return version;
  }
}
