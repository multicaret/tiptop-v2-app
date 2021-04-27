import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/profile/add_address_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_drop_down_button.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import '../UI/input/address_icon_dropdown.dart';

class AddressDetailsForm extends StatelessWidget {
  final Map<String, dynamic> addressDetailsFormData;
  final Function setAddressDetailsFormData;
  final Kind selectedKind;
  final GlobalKey<FormState> formKey;
  final Function submitForm;
  final CreateAddressData createAddressData;
  final List<Map<String, dynamic>> regionsDropDownItems;
  final bool regionsDropdownIsInvalid;
  final List<Map<String, dynamic>> citiesDropDownItems;
  final bool citiesDropdownIsInvalid;
  final List<Map<String, dynamic>> addressIconsDropDownItems;
  final TextEditingController addressAliasTextFieldController;

  AddressDetailsForm({
    @required this.addressDetailsFormData,
    @required this.selectedKind,
    @required this.formKey,
    @required this.submitForm,
    @required this.createAddressData,
    @required this.setAddressDetailsFormData,
    @required this.regionsDropDownItems,
    this.regionsDropdownIsInvalid = false,
    @required this.citiesDropDownItems,
    this.citiesDropdownIsInvalid = false,
    @required this.addressIconsDropDownItems,
    @required this.addressAliasTextFieldController,
  });

  @override
  Widget build(BuildContext context) {
    print('rebuilt AddressDetailsForm');
    return Container(
      height: AddAddressPage.addressDetailsFormContainerHeight,
      decoration: BoxDecoration(
        boxShadow: [const BoxShadow(color: AppColors.shadow, blurRadius: 6)],
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
            padding: const EdgeInsets.only(left: screenHorizontalPadding, right: screenHorizontalPadding, top: 40, bottom: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    AddressIconDropDown(
                      currentIcon: addressDetailsFormData['kind'],
                      iconItems: addressIconsDropDownItems,
                      onChanged: (kindId) {
                        setAddressDetailsFormData('kind', kindId);
                        addressAliasTextFieldController.text = createAddressData.kinds.firstWhere((kind) => kind.id == kindId).title;
                      },
                    ),
                    Expanded(
                      child: AppTextField(
                        controller: addressAliasTextFieldController,
                        labelText: 'Address Title (Home, Work)',
                        hintText: selectedKind == null ? '' : selectedKind.title,
                        required: true,
                        onSaved: (value) => setAddressDetailsFormData('alias', value),
                      ),
                    ),
                  ],
                ),
                AppDropDownButton(
                  labelText: 'City',
                  isRequired: true,
                  isInvalid: regionsDropdownIsInvalid,
                  hintText: Translations.of(context).get("Select City"),
                  defaultValue: addressDetailsFormData['region_id'],
                  items: regionsDropDownItems,
                  onChanged: (regionId) => setAddressDetailsFormData('region_id', regionId),
                ),
                AppDropDownButton(
                  labelText: 'Neighborhood',
                  isRequired: true,
                  isInvalid: citiesDropdownIsInvalid,
                  hintText: Translations.of(context).get("Select Neighborhood"),
                  defaultValue: addressDetailsFormData['city_id'],
                  items: citiesDropDownItems,
                  onChanged: (cityId) => setAddressDetailsFormData('city_id', cityId),
                ),
                AppTextField(
                  labelText: 'Address',
                  required: true,
                  maxLines: 3,
                  onSaved: (value) => setAddressDetailsFormData('address1', value),
                ),
                AppTextField(
                  labelText: 'Directions',
                  hintText: 'General explanation on how to find you',
                  onSaved: (value) => setAddressDetailsFormData('notes', value),
                ),
                AppButtons.secondary(
                  onPressed: submitForm,
                  child: Text(Translations.of(context).get("Save")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
