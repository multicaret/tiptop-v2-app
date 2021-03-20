import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/general_items.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/languages_container.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/login_header.dart';
import 'package:tiptop_v2/UI/widgets/profile-screen/logout_container.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get('Profile')),
      ),
      body: Container(
        color: AppColors.bg,
        child: SingleChildScrollView(
          child: Column(
            children: [
              LoginHeaderContainer(appProvider: appProvider),
              SizedBox(height: 30.0),
              GeneralItems(appProvider: appProvider),
              SizedBox(height: 30.0),
              if (appProvider.isAuth) LogoutContainer(appProvider: appProvider),
              SizedBox(height: 30.0),
              LanguagesContainer(appProvider: appProvider),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
