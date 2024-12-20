import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';

class LocationPermissionPage extends StatelessWidget {
  static const routeName = '/location-permission';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (c, appProvider, _) => AppScaffold(
        bodyPadding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Image(
                image: AssetImage('assets/images/location-permission-bg.png'),
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              const SizedBox(height: 20),
              Text(
                Translations.of(context).get("location permission text"),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 100),
              AppButtons.primary(
                onPressed: () {
                  handleLocationPermission().then((isGranted) {
                    print('Location granted: $isGranted');
                    if (isGranted) {
                      appProvider.setIsLocationPermissionGranted(true);
                      pushAndRemoveUntilCupertinoPage(
                        context,
                        AppWrapper(targetAppChannel: appProvider.appDefaultChannel),
                      );
                    } else {
                      openAppSettings();
                    }
                  });
                },
                child: Text(Translations.of(context).get("Use my location services")),
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  AppProvider.latitude = erbilLocation.latitude;
                  AppProvider.longitude = erbilLocation.longitude;
                  pushAndRemoveUntilCupertinoPage(
                    context,
                    AppWrapper(targetAppChannel: appProvider.appDefaultChannel),
                  );
                },
                child: Text(
                  Translations.of(context).get("I don’t want to use my location services"),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
