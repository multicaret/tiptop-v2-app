import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AppPinCodeTextField extends StatefulWidget {
  final int length;
  final Function onComplete;
  final bool autoFocus;

  const AppPinCodeTextField({this.length, this.onComplete, this.autoFocus = true});

  @override
  _AppPinCodeTextFieldState createState() => _AppPinCodeTextFieldState();
}

class _AppPinCodeTextFieldState extends State<AppPinCodeTextField> {
  TextEditingController _pinEditingController = TextEditingController(text: '');
  bool _invalidForm = false;

  @override
  Widget build(BuildContext context) {
    return PinInputTextFormField(
      autoFocus: widget.autoFocus,
      pinLength: widget.length,
      validator: (pin) => requiredFieldValidator(context, pin),
      onSaved: (pin) {
        // print('bla');
      },
      onChanged: (pin) {
        if (pin.length == widget.length) {
          widget.onComplete(pin);
        }
      },
      textInputAction: TextInputAction.next,
      controller: _pinEditingController,
      decoration: BoxLooseDecoration(
        textStyle: AppTextStyles.bodyBold,
        strokeColorBuilder: PinListenColorBuilder(AppColors.secondary, AppColors.border),
        strokeWidth: 1.5,
        radius: Radius.circular(8),
        gapSpace: 16,
        bgColorBuilder: _invalidForm ? null : PinListenColorBuilder(AppColors.bg, AppColors.bg),
        errorTextStyle: AppTextStyles.dynamicValues(color: AppColors.secondary, fontSize: 14),
      ),
    );
  }
}
