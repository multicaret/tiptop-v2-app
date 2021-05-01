import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_drop_down_button.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/otp_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../../app_wrapper.dart';

class OTPCompleteProfile extends StatefulWidget {
  static const routeName = '/otp-complete-profile';

  @override
  _OTPCompleteProfileState createState() => _OTPCompleteProfileState();
}

class _OTPCompleteProfileState extends State<OTPCompleteProfile> {
  final GlobalKey<FormState> _profileFormKey = GlobalKey();
  AppProvider appProvider;
  OTPProvider otpProvider;
  bool _isInit = true;
  bool _isLoadingCreateEditProfileRequest = false;

  Map<String, dynamic> formData = {
    'full_name': null,
    'email': null,
    'region_id': null,
    'city_id': null,
  };

  List<Map<String, dynamic>> regionsDropDownItems = [];
  List<Map<String, dynamic>> citiesDropDownItems = [];

  Future<void> _createEditProfileRequest() async {
    setState(() => _isLoadingCreateEditProfileRequest = true);
    final responseData = await otpProvider.createEditProfileRequest(appProvider);
    if (responseData == 401) {
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
      return;
    }
    regionsDropDownItems = otpProvider.regions.map((region) => {'id': region.id, 'title': region.name}).toList();
    if (formData['region_id'] != null) {
      List<City> cities = otpProvider.cities.where((city) => city.region.id == formData['region_id']).toList();
      citiesDropDownItems = cities.map((city) => {'id': city.id, 'title': city.name}).toList();
    }
    setState(() => _isLoadingCreateEditProfileRequest = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      otpProvider = Provider.of<OTPProvider>(context);
      formData = {
        'full_name':
            appProvider.authUser == null || appProvider.authUser.name.contains(appProvider.authUser.phone) ? null : appProvider.authUser.name,
        'email': appProvider.authUser == null ? null : appProvider.authUser.email,
        'region_id': appProvider.authUser == null || appProvider.authUser.region == null ? null : appProvider.authUser.region.id,
        'city_id': appProvider.authUser == null || appProvider.authUser.city == null ? null : appProvider.authUser.city.id,
      };
      _createEditProfileRequest();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    bool isProfileComplete = !appProvider.authUser.name.contains(appProvider.authUser.phone);

    return AppScaffold(
      bgImage: "assets/images/page-bg-pattern-white.png",
      bodyPadding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
      appBar: AppBar(
        title: Text(Translations.of(context).get("Complete Your Profile")),
      ),
      body: _isLoadingCreateEditProfileRequest
          ? const AppLoader()
          : SingleChildScrollView(
              child: Form(
                key: _profileFormKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      isProfileComplete ? appProvider.authUser.name : Translations.of(context).get("Final Step"),
                      style: AppTextStyles.bodyBold,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      Translations.of(context).get("Please fill out your details"),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    AppTextField(
                      keyboardType: TextInputType.name,
                      required: true,
                      labelText: 'Full Name',
                      hintText: 'John Doe',
                      initialValue: formData['full_name'],
                      onSaved: (value) {
                        formData['full_name'] = value;
                      },
                    ),
                    AppTextField(
                      textDirection: TextDirection.ltr,
                      labelText: 'Email (Optional)',
                      hintText: 'Johndoe@domain.com',
                      keyboardType: TextInputType.emailAddress,
                      initialValue: formData['email'],
                      onSaved: (value) {
                        formData['email'] = value;
                      },
                    ),
                    AppDropDownButton(
                      labelText: 'City',
                      defaultValue: formData['region_id'],
                      items: regionsDropDownItems,
                      onChanged: (regionId) {
                        setState(() => formData['region_id'] = regionId);
                        List<City> cities = otpProvider.cities.where((city) => city.region.id == regionId).toList();
                        citiesDropDownItems = cities.map((city) => {'id': city.id, 'title': city.name}).toList();
                        formData['city_id'] = null;
                      },
                      hintText: Translations.of(context).get("Select City"),
                    ),
                    AppDropDownButton(
                      labelText: 'Neighborhood',
                      defaultValue: formData['city_id'],
                      items: citiesDropDownItems,
                      hintText: Translations.of(context).get("Select Neighborhood"),
                      onChanged: (cityId) => setState(() => formData['city_id'] = cityId),
                    ),
                    AppButtons.primary(
                      child: Text(Translations.of(context).get("Save")),
                      onPressed: () => _submit(context, appProvider),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _submit(BuildContext context, AppProvider appProvider) async {
    if (!_profileFormKey.currentState.validate()) {
      showToast(msg: Translations.of(context).get("Invalid Form"));
      return;
    }
    _profileFormKey.currentState.save();
    try {
      await appProvider.updateProfile(formData);
      getLocationPermissionStatus().then((isGranted) {
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(
          isGranted ? AppWrapper.routeName : LocationPermissionPage.routeName,
        );
      });
    } on HttpException catch (error) {
      appAlert(context: context, title: 'Error Updating Profile', description: error.getErrorsAsString()).show();
      throw error;
    } catch (e) {
      print("error @submit complete profile");
      print(e.toString());
      throw e;
    }
  }
}
