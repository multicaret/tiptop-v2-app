import 'package:flutter/cupertino.dart';

void pushCupertinoPage(BuildContext context, Widget page, {bool rootNavigator = false}) {
  Navigator.of(context, rootNavigator: rootNavigator).push(
    CupertinoPageRoute<void>(
      builder: (BuildContext context) => page,
    ),
  );
}

void pushAndRemoveUntilCupertinoPage(BuildContext context, Widget page, {bool rootNavigator = true}) {
  Navigator.of(context, rootNavigator: rootNavigator).pushAndRemoveUntil(
    CupertinoPageRoute<void>(
      builder: (BuildContext context) => page,
    ),
    (Route<dynamic> route) => false,
  );
}
