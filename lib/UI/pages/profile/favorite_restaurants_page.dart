import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';

class FavoriteRestaurantsPage extends StatelessWidget {
  static const routeName = '/favorite-restaurants';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Text('Favorite Restaurants'),
      ),
    );
  }
}
