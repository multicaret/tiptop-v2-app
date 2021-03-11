import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';

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
                //Todo: show native device dialog to ask for location permission
              },
              child: Text(Translations.of(context).get('Use my location services')),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                //Todo: Open warning dialog
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
