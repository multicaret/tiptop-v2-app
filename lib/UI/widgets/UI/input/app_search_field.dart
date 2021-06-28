import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  final Function onChanged;
  final bool isLoadingSearchResult;

  AppSearchField({
    this.submitAction,
    @required this.controller,
    @required this.focusNode,
    this.onChanged,
    this.isLoadingSearchResult,
  });

  @override
  _AppSearchFieldState createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  bool _showDeleteIcon = false;
  Timer debounceTimer;

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
        // submit search with debounce timer
        if (widget.onChanged != null) {
          const duration = Duration(milliseconds: 500);
          if (debounceTimer != null) {
            setState(() => debounceTimer.cancel());
          }
          setState(
            () => debounceTimer = Timer(duration, () {
              if (this.mounted && value.length >= 3) {
                widget.onChanged(value);
              }
            }),
          );
        }
      },
      decoration: InputDecoration(
        hintText: Translations.of(context).get("Quick Search"),
        fillColor: AppColors.white,
        filled: true,
        prefixIcon: AppIcons.iconSecondary(FontAwesomeIcons.search),
        suffix: widget.isLoadingSearchResult
            ? SizedBox(
                width: 18,
                height: 18,
                child: SpinKitFadingCircle(
                  color: AppColors.primary,
                  size: 18,
                ),
              )
            : _showDeleteIcon
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
      onFieldSubmitted: (value) {
        if (widget.submitAction != null) widget.submitAction(value);
      },
    );
  }
}
