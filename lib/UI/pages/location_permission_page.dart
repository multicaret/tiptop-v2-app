import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiptop_v2/UI/pages/main_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/location_permission_dialog.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/location_helper.dart';

class LocationPermissionPage extends StatelessWidget {
  static const routeName = '/location-permission';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            Image(
              image: AssetImage('assets/images/location-permission-bg.png'),
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            SizedBox(height: 20),
            Text(
              Translations.of(context).get('location permission text'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 120),
            ElevatedButton(
              onPressed: () {
                handleLocationPermission().then((isGranted) {
                  print('Location granted: $isGranted');
                  if (isGranted) {
                    Navigator.of(context).pushReplacementNamed(MainPage.routeName);
                  } else {
                    // Navigator.of(context).pushReplacementNamed(HomePage.routeName);
                    openAppSettings();
                  }
                });
              },
              child: Text(Translations.of(context).get('Use my location services')),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => LocationPermissionDialog(
                    action: () {
                      openAppSettings();
                    },
                  ),
                ).then((_) {
                  // Navigator.of(context).pop();
                });
              },
              child: Text(
                Translations.of(context).get("I don’t want to use my location services"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
