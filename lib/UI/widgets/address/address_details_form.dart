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
  final Kind selectedKind;
  final GlobalKey<FormState> formKey;
  final Function submitForm;
  final CreateAddressData createAddressData;
  final Function setRegionId;
  final Function setCityId;
  final Function setKindId;

  AddressDetailsForm({
    @required this.addressDetailsFormData,
    @required this.selectedKind,
    @required this.formKey,
    @required this.submitForm,
    @required this.createAddressData,
    @required this.setRegionId,
    @required this.setCityId,
    @required this.setKindId,
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
    List<Map<String, dynamic>> regionsDropDownItems =
        widget.createAddressData == null ? [] : widget.createAddressData.regions.map((region) => {'id': region.id, 'name': region.name.translated}).toList();

    List<Map<String, dynamic>> citiesDropDownItems = widget.createAddressData == null
        ? []
        : widget.createAddressData.cities
            .map((city) => {
                  'id': city.id,
                  'name': city.name.translated,
                })
            .toList();

    List<Map<String, dynamic>> iconsItems = widget.createAddressData == null
        ? []
        : widget.createAddressData.kinds
            .map((kind) => {
                  'id': kind.id,
                  'icon_url': kind.icon,
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
          key: widget.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 17, right: 17, top: 40, bottom: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    AddressIconDropDown(
                      currentIcon: widget.addressDetailsFormData['kind'],
                      iconItems: iconsItems,
                      onChanged: (id) {
                        widget.setKindId(id);
                        addressAliasFieldController.text = widget.createAddressData.kinds.firstWhere((kind) => kind.id == id).title;
                      },
                    ),
                    Expanded(
                      child: AppTextField(
                        controller: addressAliasFieldController,
                        labelText: 'Address Title (Home, Work)',
                        hintText: widget.selectedKind == null ? '' : widget.selectedKind.title,
                        required: true,
                        onSaved: (value) {
                          widget.addressDetailsFormData['alias'] = value;
                        },
                      ),
                    ),
                  ],
                ),
                AppDropDownButton(
                  labelText: 'City',
                  defaultValue: widget.addressDetailsFormData['region_id'],
                  items: regionsDropDownItems,
                  onChanged: (id) => widget.setRegionId(id),
                ),
                AppDropDownButton(
                  labelText: 'Neighborhood',
                  defaultValue: widget.addressDetailsFormData['city_id'],
                  items: citiesDropDownItems,
                  onChanged: (id) => widget.setCityId(id),
                ),
                AppTextField(
                  labelText: 'Address',
                  required: true,
                  maxLines: 3,
                  onSaved: (value) {
                    widget.addressDetailsFormData['address1'] = value;
                  },
                ),
                AppTextField(
                  labelText: 'Directions',
                  hintText: 'General explanation on how to find you',
                  onSaved: (value) {
                    widget.addressDetailsFormData['notes'] = value;
                  },
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
