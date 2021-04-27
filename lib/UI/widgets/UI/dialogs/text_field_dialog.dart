import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

import 'app_alert_dialog.dart';

class TextFieldDialog extends StatefulWidget {
  final String title;
  final String image;
  final String textFieldHint;
  final TextEditingController controller;

  TextFieldDialog({
    this.title,
    this.image,
    this.textFieldHint,
    this.controller,
  });

  @override
  _TextFieldDialogState createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  TextEditingController textFieldController = TextEditingController();
  String textFieldValue = '';
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      children: [
        const SizedBox(height: 20),
        Form(
          key: _formKey,
          child: AppTextField(
            controller: textFieldController,
            labelText: Translations.of(context).get(widget.textFieldHint),
            hasInnerLabel: true,
            onSaved: (value) => textFieldValue = value,
            required: true,
            fit: true,
          ),
        ),
      ],
      actions: [
        DialogAction(
          text: 'Done',
          buttonColor: AppColors.secondary,
          onTap: _submit,
        ),
        DialogAction(
          text: 'Cancel',
          popValue: false,
        ),
      ],
    );
  }

  void _submit() {
    _formKey.currentState.save();
    if (!_formKey.currentState.validate()) {
      showToast(msg: Translations.of(context).get("Please enter coupon code!"));
      return;
    }
    Navigator.of(context).pop(textFieldValue);
  }
}
