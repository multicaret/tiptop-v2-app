import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/food/active_filters.dart';
import 'package:tiptop_v2/UI/widgets/food/filter_sort_buttons.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurants_index.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class RestaurantsPage extends StatefulWidget {
  static const routeName = '/restaurants';

  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  bool _isInit = true;
  RestaurantsProvider restaurantsProvider;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      restaurantsProvider = Provider.of<RestaurantsProvider>(context);
      final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      int initiallySelectedCategoryId = data == null ? null : data['selected_category_id'];
      if (initiallySelectedCategoryId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          restaurantsProvider.setFilterData(key: 'categories', value: [initiallySelectedCategoryId]);
          restaurantsProvider.submitFiltersAndSort();
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasOverlayLoader: restaurantsProvider.isLoadingSubmitFilterAndSort,
      appBarActions: [
        if (!restaurantsProvider.filtersAreEmpty)
          IconButton(
            onPressed: () {
              restaurantsProvider.setFilterData(data: {
                'delivery_type': 'all',
                'min_rating': null,
                'minimum_order': restaurantsProvider.minCartValue,
                'categories': <int>[],
              });
              restaurantsProvider.submitFiltersAndSort();
            },
            icon: AppIcons.icon(FontAwesomeIcons.eraser),
          )
      ],
      body: Column(
        children: [
          FilterSortButtons(shouldPopOnly: true),
          ActiveFilters(),
          Expanded(
            child: restaurantsProvider.filteredRestaurants.length == 0
                ? Center(
                    child: Text(Translations.of(context).get("No Results Match Your Search")),
                  )
                : SingleChildScrollView(
                    child: RestaurantsIndex(isFiltered: true),
                  ),
          ),
        ],
      ),
    );
  }
}
