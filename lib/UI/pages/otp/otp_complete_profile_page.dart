import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_drop_down_button.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_searchable_drop_down.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/otp_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/http_exception.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../../app_wrapper.dart';

class OTPCompleteProfile extends StatefulWidget {
  static const routeName = '/otp-complete-profile';

  @override
  _OTPCompleteProfileState createState() => _OTPCompleteProfileState();
}

class _OTPCompleteProfileState extends State<OTPCompleteProfile> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final GlobalKey<FormState> _profileFormKey = GlobalKey();
  AppProvider appProvider;
  OTPProvider otpProvider;

  bool _isUpdatingProfile = false;
  bool _completingProfile = false;
  bool _isLoadingUpdateProfileRequest = false;
  bool _isInit = true;
  bool _isLoadingCreateEditProfileRequest = false;

  String selectedOTPMethod;

  Map<String, dynamic> formData = {
    'full_name': null,
    'email': null,
    'region_id': null,
    'city_id': null,
  };

  IdName selectedCity;

  List<Map<String, dynamic>> regionsDropDownItems = [];
  List<Map<String, dynamic>> citiesDropDownItems = [];

  Future<void> _createEditProfileRequest() async {
    setState(() => _isLoadingCreateEditProfileRequest = true);
    final responseData = await otpProvider.createEditProfileRequest(appProvider);
    if (responseData == 401) {
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        WalkthroughPage.routeName,
        (Route<dynamic> route) => false,
      );
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
      final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic> ?? {};

      _isUpdatingProfile = data["updating_profile"] ?? false;
      selectedOTPMethod = data["selected_otp_method"];
      _completingProfile = data["completing_profile"] ?? false;
      print('route data: $data');

      appProvider = Provider.of<AppProvider>(context);
      otpProvider = Provider.of<OTPProvider>(context);

      if (appProvider.authUser != null) {
        //User exists, init form data with their info
        formData = {
          'full_name': appProvider.authUser.name.contains(appProvider.authUser.phone) ? null : appProvider.authUser.name,
          'email': appProvider.authUser.email,
          'region_id': appProvider.authUser.region == null ? null : appProvider.authUser.region.id,
          'city_id': appProvider.authUser.city == null ? null : appProvider.authUser.city.id,
        };
        if (appProvider.authUser.city != null) {
          selectedCity = IdName(id: appProvider.authUser.city.id, name: appProvider.authUser.city.name);
        }
      }
      _createEditProfileRequest();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    bool isProfileComplete = !appProvider.authUser.name.contains(appProvider.authUser.phone);

    return WillPopScope(
      onWillPop: () async => _isUpdatingProfile,
      child: AppScaffold(
        bgImage: "assets/images/page-bg-pattern-white.png",
        bodyPadding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
        hasOverlayLoader: _isLoadingUpdateProfileRequest,
        appBar: AppBar(
          automaticallyImplyLeading: _isUpdatingProfile,
          title: Text(Translations.of(context).get(_isUpdatingProfile ? "Profile" : "Complete Your Profile")),
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
                        hintText: Translations.of(context).get("John Doe"),
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
                          selectedCity = null;
                        },
                        hintText: Translations.of(context).get("Select City"),
                      ),
                      IgnorePointer(
                        ignoring: formData['region_id'] == null,
                        child: AppSearchableDropDown(
                          labelText: 'Neighborhood',
                          hintText: 'Select Neighborhood',
                          items: citiesDropDownItems.map((city) => IdName(id: city['id'], name: city['title'])).toList(),
                          onChanged: (IdName _selectedCity) {
                            setState(() {
                              selectedCity = _selectedCity;
                              formData['city_id'] = _selectedCity.id;
                            });
                          },
                          selectedItem: selectedCity != null ? selectedCity : null,
                        ),
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
      ),
    );
  }

  EventTracking eventTracking = EventTracking.getActions();

  Future<void> trackCompleteRegistrationEvent() async {
    //Todo: remove this check, might be unnecessary
    if (appProvider.authUser == null) {
      print('No user!');
      return;
    }
    Map<String, dynamic> eventParams = {
      'phone': '${appProvider.authUser.phoneCode}${appProvider.authUser.phone}',
      'registration_date': appProvider.authUser.approvedAt.timestamp,
      'registration_method': selectedOTPMethod,
      'name': appProvider.authUser.name,
      'email': appProvider.authUser.email,
    };
    await eventTracking.trackEvent(TrackingEvent.COMPLETE_REGISTRATION, eventParams);
  }

  Future<void> _submit(BuildContext context, AppProvider appProvider) async {
    if (!_profileFormKey.currentState.validate()) {
      showToast(msg: Translations.of(context).get("Invalid Form"));
      return;
    }
    _profileFormKey.currentState.save();
    try {
      setState(() => _isLoadingUpdateProfileRequest = true);
      await appProvider.updateProfile(formData);
      setState(() => _isLoadingUpdateProfileRequest = false);
      if (_isUpdatingProfile) {
        Navigator.of(context).pop();
      } else {
        //Track complete registration event
        await trackCompleteRegistrationEvent();
        getLocationPermissionStatus().then((isGranted) {
          if (isGranted) {
            if (_completingProfile) {
              Navigator.of(context).pop();
            } else {
              pushAndRemoveUntilCupertinoPage(
                context,
                AppWrapper(targetAppChannel: appProvider.appDefaultChannel),
              );
            }
          } else {
            Navigator.of(context).pushReplacementNamed(LocationPermissionPage.routeName);
          }
        });
      }
    } on HttpException catch (error) {
      appAlert(
        context: context,
        title: Translations.of(context).get("Please make sure the following is corrected"),
        description: error.getErrorsAsString(),
      ).show();
      throw error;
    } catch (e) {
      print("error @submit complete profile");
      print(e.toString());
      throw e;
    }
  }
}
