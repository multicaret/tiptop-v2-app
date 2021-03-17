import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (appProvider.isAuth) {
            appProvider.logout();
          } else {
            Navigator.of(context).pushNamed(WalkthroughPage.routeName);
          }
        },
        child: Text(appProvider.isAuth ? 'Logout' : 'Login'),
      ),
    );
  }
}
