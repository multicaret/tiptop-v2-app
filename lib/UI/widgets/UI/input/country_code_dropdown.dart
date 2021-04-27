import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CountryCodeDropDown extends StatelessWidget {
  final List<Country> countries;
  final String currentCountryPhoneCode;
  final Function onChange;

  CountryCodeDropDown({
    @required this.countries,
    @required this.currentCountryPhoneCode,
    @required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            Translations.of(context).get("Country Code"),
            style: AppTextStyles.bodyBold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: AppColors.bg,
            border: Border.all(color: AppColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(canvasColor: AppColors.bg),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentCountryPhoneCode,
                icon: AppIcons.icon(FontAwesomeIcons.angleDown),
                isExpanded: true,
                onChanged: onChange,
                items: <Country>[...countries].map<DropdownMenuItem<String>>((Country country) {
                  return DropdownMenuItem<String>(
                    value: country.phoneCode,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          SvgPicture.network(
                            country.flagUrl,
                            width: 30,
                            alignment: Alignment.center,
                            placeholderBuilder: (BuildContext context) => Container(
                              child: SpinKitCircle(
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text('${country.phoneCode}'),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
