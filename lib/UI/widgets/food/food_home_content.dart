import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurants_index.dart';
import 'package:tiptop_v2/dummy_data.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class FoodHomeContent extends StatefulWidget {
  final HomeData foodHomeData;
  final bool isLoadingHomeData;

  FoodHomeContent({
    @required this.foodHomeData,
    @required this.isLoadingHomeData,
  });

  @override
  _FoodHomeContentState createState() => _FoodHomeContentState();
}

class _FoodHomeContentState extends State<FoodHomeContent> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return widget.isLoadingHomeData
        ? const AppLoader()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionTitle('Categories'),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: AppColors.white,
                child: CategoriesSlider(categories: dummyFoodCategories, isRTL: appProvider.isRTL),
              ),
              RestaurantsIndex(),
            ],
          );
  }
}
