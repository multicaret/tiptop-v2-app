import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';

class SupportPage extends StatelessWidget {
  static const routeName = '/support';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).get('Support')),
      ),
      body: Center(
        child: Text('Support Page'),
      ),
    );
  }
}
