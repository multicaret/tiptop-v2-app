import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurants_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/UI/widgets/food/filter_sort_buttons.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurants_index.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class FoodHomeContent extends StatelessWidget {
  final HomeData foodHomeData;

  FoodHomeContent({
    @required this.foodHomeData,
  });

  @override
  Widget build(BuildContext context) {
    print("rebuilt food home content");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle('Categories'),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: AppColors.white,
          child: CategoriesSlider(categories: foodHomeData.categories),
        ),
        FilterSortButtons(),
        RestaurantsIndex(),
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushNamed(RestaurantsPage.routeName);
          },
          child: Consumer<AppProvider>(
            builder: (c, appProvider, _) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Translations.of(context).get("View All")),
                const SizedBox(width: 5),
                AppIcons.iconSm(appProvider.isRTL ? FontAwesomeIcons.chevronLeft : FontAwesomeIcons.chevronRight),
              ],
            ),
          ),
        )
      ],
    );
  }
}
