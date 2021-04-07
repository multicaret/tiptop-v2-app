import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/pages/profile/add_address_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_drop_down_button.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import '../UI/input/address_icon_dropdown.dart';

class AddressDetailsForm extends StatefulWidget {
  final Map<String, dynamic> addressDetailsFormData;
  final Function setAddressDetailsFormData;
  final Kind selectedKind;
  final GlobalKey<FormState> formKey;
  final Function submitForm;
  final CreateAddressData createAddressData;
  final List<Map<String, dynamic>> regionsDropDownItems;
  final List<Map<String, dynamic>> citiesDropDownItems;
  final List<Map<String, dynamic>> addressIconsDropDownItems;

  AddressDetailsForm({
    @required this.addressDetailsFormData,
    @required this.selectedKind,
    @required this.formKey,
    @required this.submitForm,
    @required this.createAddressData,
    @required this.setAddressDetailsFormData,
    @required this.regionsDropDownItems,
    @required this.citiesDropDownItems,
    @required this.addressIconsDropDownItems,
  });

  @override
  _AddressDetailsFormState createState() => _AddressDetailsFormState();
}

class _AddressDetailsFormState extends State<AddressDetailsForm> {
  TextEditingController addressAliasFieldController = new TextEditingController();

  @override
  void initState() {
    addressAliasFieldController.text = widget.selectedKind.title;
    super.initState();
  }

  @override
  void dispose() {
    addressAliasFieldController.dispose();
    super.dispose();
  }

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
          key: widget.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 17, right: 17, top: 40, bottom: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    AddressIconDropDown(
                      currentIcon: widget.addressDetailsFormData['kind'],
                      iconItems: widget.addressIconsDropDownItems,
                      onChanged: (kindId) {
                        widget.setAddressDetailsFormData('kind', kindId);
                        addressAliasFieldController.text = widget.createAddressData.kinds.firstWhere((kind) => kind.id == kindId).title;
                      },
                    ),
                    Expanded(
                      child: AppTextField(
                        controller: addressAliasFieldController,
                        labelText: 'Address Title (Home, Work)',
                        hintText: widget.selectedKind == null ? '' : widget.selectedKind.title,
                        required: true,
                        onSaved: (value) => widget.setAddressDetailsFormData('alias', value),
                      ),
                    ),
                  ],
                ),
                AppDropDownButton(
                  labelText: 'City',
                  defaultValue: widget.addressDetailsFormData['region_id'],
                  items: widget.regionsDropDownItems,
                  onChanged: (regionId) => widget.setAddressDetailsFormData('region_id', regionId),
                ),
                AppDropDownButton(
                  labelText: 'Neighborhood',
                  hintText: 'Select Neighborhood',
                  defaultValue: widget.addressDetailsFormData['city_id'],
                  items: widget.citiesDropDownItems,
                  onChanged: (cityId) => widget.setAddressDetailsFormData('city_id', cityId),
                ),
                AppTextField(
                  labelText: 'Address',
                  required: true,
                  maxLines: 3,
                  onSaved: (value) => widget.setAddressDetailsFormData('address1', value),
                ),
                AppTextField(
                  labelText: 'Directions',
                  hintText: 'General explanation on how to find you',
                  onSaved: (value) => widget.setAddressDetailsFormData('notes', value),
                ),
                AppButtons.secondary(
                  onPressed: widget.submitForm,
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
