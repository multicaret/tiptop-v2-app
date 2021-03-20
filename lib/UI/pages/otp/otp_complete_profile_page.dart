import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../../app_wrapper.dart';

class OTPCompleteProfile extends StatelessWidget {
  static const routeName = '/otp-complete-profile';

  static Map<String, dynamic> formData = {
    'full_name': '',
    'email': '',
    'region_id': 2,
    'city_id': 1,
  };

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyPadding: EdgeInsets.symmetric(horizontal: 17.0),
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
              labelText: 'Full Name',
              hintText: 'John Doe',
              onSaved: (value) {
                formData['full_name'] = value;
              },
            ),
            AppTextField(
              labelText: 'Email (Optional)',
              hintText: 'Johndoe@domain.com',
              onSaved: (value) {
                formData['email'] = value;
              },
            ),
            AppTextField(
              labelText: 'City',
              hintText: 'Erbil',
              /*onSaved: (value) {
                formData['region_id'] = value;
              },*/
            ),
            AppTextField(
              labelText: 'Neighborhood',
              hintText: 'Italian Town',
              /*onSaved: (value) {
                formData['city_id'] = value;
              },*/
            ),
            ElevatedButton(
              child: Text(Translations.of(context).get('Save')),
              onPressed: () {
                getLocationPermissionStatus().then((isGranted) {
                  Navigator.of(context).pushReplacementNamed(isGranted ? AppWrapper.routeName : LocationPermissionPage.routeName);
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
