import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AppSearchableDropDown extends StatelessWidget {
  final String labelText;
  final String hintText;
  final List<IdName> items;
  final IdName selectedItem;
  final Function onChanged;

  AppSearchableDropDown({
    @required this.labelText,
    @required this.hintText,
    @required this.items,
    @required this.onChanged,
    @required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Translations.of(context).get(labelText),
          style: AppTextStyles.bodyBold,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 20),
          child: Consumer(
            builder: (BuildContext context, AppProvider appProvider, Widget child) {
              return DropdownSearch<IdName>(
                items: items,
                itemAsString: (IdName item) => item.name,
                selectedItem: selectedItem,
                hint: Translations.of(context).get(hintText),
                showSearchBox: true,
                dropDownButton: AppIcons.icon(FontAwesomeIcons.angleDown),
                onChanged: (IdName selectedItem) => onChanged(selectedItem),
                //Custom dropdown list
                popupItemBuilder: (BuildContext context, IdName item, bool isSelected) {
                  if (item == null) {
                    return Container();
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: listItemVerticalPaddingSm),
                    child: Text(item.name),
                  );
                },
                //Custom selected item
                dropdownBuilder: (BuildContext context, IdName item, _) {
                  if (item == null) {
                    return Container();
                  }
                  return Container(
                    child: Text(item.name),
                  );
                },
                dropdownSearchDecoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.bg,
                  contentPadding: EdgeInsets.only(
                    left: appProvider.isRTL ? 5 : screenHorizontalPadding,
                    right: appProvider.isRTL ? screenHorizontalPadding : 5,
                    top: 5,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(width: 1.5, color: AppColors.border),
                  ),
                ),
                searchFieldProps: TextFieldProps(
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1.5, color: AppColors.secondary),
                    ),
                    contentPadding: EdgeInsets.only(
                      left: appProvider.isRTL ? 0 : screenHorizontalPadding,
                      right: appProvider.isRTL ? 0 : 5,
                      top: 5,
                    ),
                    prefixIcon: AppIcons.iconSm(FontAwesomeIcons.search),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
