import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../main_page.dart';

class OTPCompleteProfile extends StatelessWidget {
  static const routeName = '/otp-complete-profile';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        //Todo: Uncomment this line when OTP is implemented
        // automaticallyImplyLeading: false,
        title: Text(Translations.of(context).get('Complete Your Profile')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              Translations.of(context).get('Final Step'),
              style: AppTextStyles.bodyBold,
              textAlign: TextAlign.center,
            ),
            Text(
              Translations.of(context).get('Please fill out your details'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            AppTextField(
              labelText: 'First',
              hintText: 'John',
            ),
            AppTextField(
              labelText: 'Last',
              hintText: 'Doe',
            ),
            AppTextField(
              labelText: 'Email (Optional)',
              hintText: 'Johndoe@domain.com',
            ),
            AppTextField(
              labelText: 'City',
              hintText: 'Erbil',
            ),
            AppTextField(
              labelText: 'Neighborhood',
              hintText: 'French Town',
            ),
            ElevatedButton(
              child: Text(Translations.of(context).get('Save')),
              onPressed: () {
                getLocationPermissionStatus().then((isGranted) {
                  Navigator.of(context).pushReplacementNamed(isGranted ? MainPage.routeName : LocationPermissionPage.routeName);
                });
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
