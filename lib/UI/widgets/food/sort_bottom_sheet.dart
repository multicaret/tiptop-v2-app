import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/food/restaurants/restaurants_page.dart';
import 'package:tiptop_v2/UI/pages/location_permission_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_bottom_sheet.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_list_items.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/location_helper.dart';
import 'package:tiptop_v2/utils/navigator_helper.dart';

class SortBottomSheet extends StatefulWidget {
  final bool shouldPopOnly;

  SortBottomSheet({this.shouldPopOnly = false});

  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  List<Map<String, dynamic>> _getSortItems(BuildContext context) {
    return [
      {
        'id': RestaurantSortType.SMART,
        'title': Translations.of(context).get("Smart Sorting"),
        'icon': FontAwesomeIcons.listUl,
      },
      {
        'id': RestaurantSortType.RATING,
        'title': Translations.of(context).get("Restaurant Rating"),
        'icon': FontAwesomeIcons.star,
      },
      {
        'id': RestaurantSortType.DISTANCE,
        'title': Translations.of(context).get("By Distance"),
        'icon': FontAwesomeIcons.mapMarkerAlt,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RestaurantsProvider, AddressesProvider>(
      builder: (c, restaurantsProvider, addressesProvider, _) {
        return AppBottomSheet(
          hasButtonLoader: restaurantsProvider.isLoadingSubmitFilterAndSort,
          screenHeightFraction: 0.45,
          applyAction: () => _submitSort(restaurantsProvider, addressesProvider),
          title: 'Sort',
          children: [
            Column(
              children: [
                RadioListItems(
                  items: _getSortItems(context),
                  selectedId: restaurantsProvider.sortType,
                  action: restaurantsProvider.isLoadingSubmitFilterAndSort ? null : (value) => restaurantsProvider.setSortType(value),
                  hasBorder: false,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitSort(RestaurantsProvider restaurantsProvider, AddressesProvider addressesProvider) async {
    try {
      Map<String, dynamic> sortData;
      if (restaurantsProvider.sortType == RestaurantSortType.DISTANCE) {
        if (AppProvider.latitude == null || AppProvider.longitude == null) {
          print('Lat/Long not found!');
          bool isGranted = await getLocationPermissionStatus();
          if (!isGranted) {
            Navigator.of(context, rootNavigator: true).pushReplacementNamed(LocationPermissionPage.routeName);
            return;
          } else {
            await updateLocationAndStoreIt();
          }
        }
        sortData = {
          'latitude': AppProvider.latitude,
          'longitude': AppProvider.longitude,
          'selected_address_id':
              addressesProvider.addressIsSelected && addressesProvider.selectedAddress != null ? addressesProvider.selectedAddress.id : null,
        };
      }
      await restaurantsProvider.submitFiltersAndSort(sortData: sortData);
      showToast(msg: '${restaurantsProvider.filteredRestaurants.length} ${Translations.of(context).get("result(s) match your search")}');
      Navigator.of(context).pop();
      if (!widget.shouldPopOnly) {
        pushCupertinoPage(context, RestaurantsPage());
      }
    } catch (e) {
      throw e;
    }
  }
}
