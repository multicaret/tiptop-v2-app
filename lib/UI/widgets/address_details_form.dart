import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/input/app_text_field.dart';
import 'package:tiptop_v2/models/address.dart';

class AddressDetailsForm extends StatelessWidget {
  final Map<String, dynamic> addressDetailsFormData;
  final Kind selectedKind;
  final GlobalKey<FormState> formKey;

  AddressDetailsForm({
    @required this.addressDetailsFormData,
    @required this.selectedKind,
    @required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 17, right: 17, top: 20, bottom: 40),
        child: Column(
          children: [
            AppTextField(
              labelText: 'Address Title (Home, Work)',
              hintText: selectedKind == null ? '' : selectedKind.title,
              onSaved: (value) {
                addressDetailsFormData['alias'] = value;
              },
            ),
            AppTextField(
              labelText: 'Address',
              onSaved: (value) {
                addressDetailsFormData['address1'] = value;
              },
            ),
            AppTextField(
              labelText: 'Directions',
              hintText: 'General explanation on how to find you',
              maxLines: 3,
              onSaved: (value) {
                addressDetailsFormData['notes'] = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
