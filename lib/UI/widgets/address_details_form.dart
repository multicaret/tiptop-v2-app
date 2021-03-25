import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/add_address_page.dart';
import 'package:tiptop_v2/UI/widgets/input/app_drop_down_button.dart';
import 'package:tiptop_v2/UI/widgets/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class AddressDetailsForm extends StatelessWidget {
  final Map<String, dynamic> addressDetailsFormData;
  final Kind selectedKind;
  final GlobalKey<FormState> formKey;
  final Function submitForm;
  final CreateAddressData createAddressData;
  final Function setRegionId;
  final Function setCityId;

  AddressDetailsForm({
    @required this.addressDetailsFormData,
    @required this.selectedKind,
    @required this.formKey,
    @required this.submitForm,
    @required this.createAddressData,
    @required this.setRegionId,
    @required this.setCityId,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> regionsDropDownItems = createAddressData == null
        ? []
        : createAddressData.regions
            .map((region) => {
                  'id': region.id,
                  'name': region.name.translated
                })
            .toList();

    List<Map<String, dynamic>> citiesDropDownItems = createAddressData == null
        ? []
        : createAddressData.cities
            .map((city) => {
                  'id': city.id,
                  'name': city.name.translated,
                })
            .toList();

    return Container(
      height: AddAddressPage.addressDetailsFormContainerHeight,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 17, right: 17, top: 40, bottom: 40),
            child: Column(
              children: [
                AppTextField(
                  labelText: 'Address Title (Home, Work)',
                  initialValue: selectedKind == null ? '' : selectedKind.title,
                  required: true,
                  onSaved: (value) {
                    addressDetailsFormData['alias'] = value;
                  },
                ),
                AppDropDownButton(
                  labelText: 'City',
                  defaultValue: addressDetailsFormData['region_id'],
                  items: regionsDropDownItems,
                  onChanged: (id) => setRegionId(id),
                ),
                AppDropDownButton(
                  labelText: 'Neighborhood',
                  defaultValue: addressDetailsFormData['city_id'],
                  items: citiesDropDownItems,
                  onChanged: (id) => setCityId(id),
                ),
                AppTextField(
                  labelText: 'Address',
                  required: true,
                  maxLines: 3,
                  onSaved: (value) {
                    addressDetailsFormData['address1'] = value;
                  },
                ),
                AppTextField(
                  labelText: 'Directions',
                  hintText: 'General explanation on how to find you',
                  onSaved: (value) {
                    addressDetailsFormData['notes'] = value;
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.secondaryDark,
                    onPrimary: AppColors.primary,
                  ),
                  onPressed: submitForm,
                  child: Text(Translations.of(context).get('Save')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
