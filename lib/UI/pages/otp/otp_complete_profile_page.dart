import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../../app_wrapper.dart';

class OTPCompleteProfile extends StatelessWidget {
  static const routeName = '/otp-complete-profile';
  final GlobalKey<FormState> _formKeyFoo = GlobalKey();

  static Map<String, dynamic> formData = {
    'full_name': null,
    'email': null,
    'region_id': 2,
    'city_id': 1,
  };

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return AppScaffold(
      bgImage: "assets/images/page-bg-pattern-white.png",
      bodyPadding: EdgeInsets.symmetric(horizontal: 17.0),
      appBar: AppBar(
        //Todo: Uncomment this line when OTP is implemented
        // automaticallyImplyLeading: false,
        title: Text(Translations.of(context).get('Complete Your Profile')),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKeyFoo,
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                appProvider.isAuth ? appProvider.authUser.name : Translations.of(context).get("Final Step"),
                style: AppTextStyles.bodyBold,
                textAlign: TextAlign.center,
              ),
              Text(
                Translations.of(context).get('Please fill out your details'),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              AppTextField(
                required: true,
                // validator: (val) => val.isEmpty ? Translations.of(context).get('Invalid') : null,
                labelText: 'Full Name',
                hintText: 'John Doe',
                onSaved: (value) {
                  formData['full_name'] = value;
                },
              ),
              AppTextField(
                textDirection: TextDirection.ltr,
                labelText: 'Email (Optional)',
                hintText: 'Johndoe@domain.com',
                keyboardType: TextInputType.emailAddress,
                // validator: (val) => !val.contains("@") ? "Enter a valid email" : null,
                onSaved: (value) {
                  formData['email'] = value;
                },
              ),
              /*AppTextField(
                labelText: 'City',
                hintText: 'Erbil',
                */ /*onSaved: (value) {
                  formData['region_id'] = value;
                },*/ /*
              ),
              AppTextField(
                labelText: 'Neighborhood',
                hintText: 'Italian Town',
                */ /*onSaved: (value) {
                  formData['city_id'] = value;
                },*/ /*
              ),*/
              ElevatedButton(
                child: Text(Translations.of(context).get('Save')),
                onPressed: () => _submit(context, appProvider),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, AppProvider appProvider) async {
    if (!_formKeyFoo.currentState.validate()) {
      showToast(msg: Translations.of(context).get('Invalid Form'));
      return;
    }
    _formKeyFoo.currentState.save();
    print(formData);
    try {
      // Todo: store user
      // Response is received as null
      await appProvider.updateProfile(formData);
      getLocationPermissionStatus().then((isGranted) {
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(
          isGranted ? AppWrapper.routeName : LocationPermissionPage.routeName,
        );
      });
    } catch (e) {
      throw e;
    }
  }
}
