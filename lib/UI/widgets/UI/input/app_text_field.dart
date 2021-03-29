import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final IconData prefixIconData;
  final int maxLines;
  final Function onSaved;
  final Function onEditingComplete;
  final Function onFieldSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final String initialValue;
  final FormFieldValidator validator;
  final TextInputType keyboardType;
  final Function onTap;
  final bool readOnly;
  final bool required;
  final bool isPassword;
  final bool hasInnerLabel;
  final bool fit;
  final TextDirection textDirection;
  final bool hasClearIcon;
  final TextEditingController controller;

  AppTextField({
    this.labelText,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixIconData,
    this.maxLines = 1,
    this.onSaved,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.initialValue,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
    this.required = false,
    this.isPassword = false,
    this.hasInnerLabel = false,
    this.fit = false,
    this.textDirection,
    this.hasClearIcon = false,
    this.controller,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  TextStyle labelStyle = AppTextStyles.bodyBold;
  TextStyle innerLabelStyle = AppTextStyles.body;
  Color inputColor = AppColors.text50;
  FocusNode _focusNode = new FocusNode();
  final TextEditingController _controller = new TextEditingController();
  bool _hidePassword = true;
  bool _showDeleteIcon = false;

  @override
  void initState() {
    _focusNode.addListener(_handleFocusChange);
    super.initState();
  }

  void _handleFocusChange() {
    setState(() {
      labelStyle = _focusNode.hasFocus ? AppTextStyles.bodyBoldSecondaryDark : AppTextStyles.bodyBold;
      innerLabelStyle = _focusNode.hasFocus ? AppTextStyles.bodySecondary : AppTextStyles.body;
      inputColor = _focusNode.hasFocus ? AppColors.primary : AppColors.text50;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.fit ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!widget.hasInnerLabel)
            Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                Translations.of(context).get(widget.labelText),
                style: labelStyle,
              ),
            ),
          TextFormField(
            controller: widget.hasClearIcon ? _controller : widget.controller,
            validator: widget.validator == null && widget.required ? (value) => requiredFieldValidator(context, value) : widget.validator,
            focusNode: _focusNode,
            obscureText: widget.isPassword ? _hidePassword : false,
            maxLines: widget.maxLines,
            initialValue: widget.initialValue,
            keyboardType: widget.keyboardType,
            textInputAction: TextInputAction.done,
            textDirection: widget.textDirection,
            onChanged: (value) {
              setState(() {
                _showDeleteIcon = value.isNotEmpty;
              });
            },
            decoration: InputDecoration(
              labelText: widget.hasInnerLabel ? Translations.of(context).get(widget.labelText) : null,
              labelStyle: innerLabelStyle,
              alignLabelWithHint: true,
              prefixIcon: _getPrefixIcon(context),
              suffixIcon: _getSuffixIcon(context),
              hintText: widget.hintText,
              hintTextDirection: widget.textDirection,
              contentPadding: EdgeInsets.symmetric(vertical: widget.maxLines > 1 ? 20 : 0, horizontal: 20),
              filled: true,
              fillColor: AppColors.bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(width: 1.5, color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(width: 1.5, color: AppColors.secondaryDark),
              ),
            ),
            onSaved: widget.onSaved,
            onTap: widget.onTap,
            onEditingComplete: widget.onEditingComplete,
            onFieldSubmitted: widget.onFieldSubmitted,
            inputFormatters: widget.inputFormatters,
            readOnly: widget.readOnly,
          ),
        ],
      ),
    );
  }

  Widget _getPrefixIcon(BuildContext context) {
    return widget.prefixIcon != null
        ? widget.prefixIcon
        : widget.prefixIconData == null
            ? null
            : Icon(
                widget.prefixIconData,
                color: AppColors.primary,
                size: 18,
              );
  }

  Widget _getSuffixIcon(BuildContext context) {
    return widget.suffixIcon != null
        ? widget.suffixIcon
        : widget.isPassword
            ? IconButton(
                icon: Icon(
                  _hidePassword ? Icons.visibility : Icons.visibility_off,
                  color: inputColor,
                ),
                onPressed: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
              )
            : widget.hasClearIcon && _showDeleteIcon
                ? IconButton(
                    icon: Icon(
                      FontAwesomeIcons.times,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
                      _focusNode.unfocus();
                      setState(() {
                        _showDeleteIcon = false;
                      });
                    },
                  )
                : null;
  }
}
