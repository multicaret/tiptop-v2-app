import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class AppSearchField extends StatefulWidget {
  final Function submitAction;
  final TextEditingController controller;
  final FocusNode focusNode;

  AppSearchField({
    @required this.submitAction,
    @required this.controller,
    @required this.focusNode,
  });

  @override
  _AppSearchFieldState createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  bool _showDeleteIcon = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      validator: (value) => requiredFieldValidator(context, value),
      onChanged: (value) {
        setState(() {
          _showDeleteIcon = value.isNotEmpty;
        });
      },
      decoration: InputDecoration(
        hintText: Translations.of(context).get("Quick Search"),
        fillColor: AppColors.white,
        filled: true,
        prefixIcon: AppIcons.iconSecondary(FontAwesomeIcons.search),
        suffix: _showDeleteIcon
            ? GestureDetector(
                child: AppIcons.iconSm50(FontAwesomeIcons.solidTimesCircle),
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) => widget.controller.clear());
                  widget.focusNode.unfocus();
                  setState(() {
                    _showDeleteIcon = false;
                  });
                },
              )
            : null,
        border: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: AppColors.border),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: AppColors.border),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: AppColors.secondary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
      ),
      onFieldSubmitted: (value) => widget.submitAction(value),
    );
  }
}
