import 'package:flutter/material.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class CategoriesSlider extends StatelessWidget {
  final List<Map<String, dynamic>> categoriesItems;
  final bool isRTL;

  CategoriesSlider({@required this.categoriesItems, @required this.isRTL});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
      color: AppColors.white,
      height: 110,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 10);
        },
        itemCount: categoriesItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Padding(
            padding: isRTL
                ? EdgeInsets.only(right: i == 0 ? 17 : 0, left: i == categoriesItems.length - 1 ? 17 : 0)
                : EdgeInsets.only(left: i == 0 ? 17 : 0, right: i == categoriesItems.length - 1 ? 17 : 0),
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
                        categoriesItems[i]['image'],
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
                      categoriesItems[i]['title'],
                      style: AppTextStyles.subtitleWhite,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
