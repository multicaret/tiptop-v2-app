import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/general_items.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/laguage_container.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/logout_container.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/login_header.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    //TODO: Remove curve
    return SingleChildScrollView(
      child: Column(
        children: [
          LoginHeaderContainer(appProvider: appProvider),
          coloredSizedBox(30.0),
          GeneralItems(appProvider: appProvider),
          coloredSizedBox(50.0),
          LogoutContainer(appProvider: appProvider),
          coloredSizedBox(50.0),
          LanguageContainer(appProvider: appProvider),
        ],
      ),
    );
  }

  SizedBox coloredSizedBox(double height) {
    return SizedBox(
      height: height,
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
      ),
    );
  }
}
