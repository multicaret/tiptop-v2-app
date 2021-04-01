import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FoodCategoryItem extends StatelessWidget {
  final Category category;
  final int index;
  final int count;
  final bool isRTL;

  const FoodCategoryItem({
    @required this.category,
    @required this.index,
    @required this.count,
    @required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isRTL
          ? EdgeInsets.only(right: index == 0 ? 17 : 0, left: index == count - 1 ? 17 : 0)
          : EdgeInsets.only(left: index == 0 ? 17 : 0, right: index == count - 1 ? 17 : 0),
      child: Stack(
        children: [
          Container(
            width: 116,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'assets/images/food.jpg',
                ),
              ),
              color: AppColors.primary50,
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.transparent, AppColors.primary], // red to yellow
                ),
              ),
              child: Text(
                category.title,
                style: AppTextStyles.subtitleWhite,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
