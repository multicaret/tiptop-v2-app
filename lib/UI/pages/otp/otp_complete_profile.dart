import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

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
              initialValue: 'John',
            ),
            AppTextField(
              labelText: 'Last',
              initialValue: 'Doe',
            ),
            AppTextField(
              labelText: 'Email (Optional)',
              initialValue: 'Johndoe@domain.com',
            ),
            AppTextField(
              labelText: 'City',
              initialValue: 'Erbil',
            ),
            AppTextField(
              labelText: 'Neighborhood',
              initialValue: 'French Town',
            ),
            ElevatedButton(
              child: Text(Translations.of(context).get('Save')),
              onPressed: () {
                Navigator.of(context).pushNamed(LocationPermissionPage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
