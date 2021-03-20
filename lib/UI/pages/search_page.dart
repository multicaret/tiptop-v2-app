import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: Center(
      child: Text('Search Page'),
    ));
  }
}
