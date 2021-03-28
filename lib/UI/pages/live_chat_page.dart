import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';

class LiveChatPage extends StatelessWidget {
  static const routeName = '/live-chat';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get('Live Chat')),
      ),
    );
  }
}
