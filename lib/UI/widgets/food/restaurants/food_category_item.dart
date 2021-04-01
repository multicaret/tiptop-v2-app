import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class FoodCategoryItem extends StatefulWidget {
  final Category category;
  final int index;
  final int count;
  final bool isRTL;
  final bool isSelectable;

  const FoodCategoryItem({
    @required this.category,
    @required this.index,
    @required this.count,
    @required this.isRTL,
    this.isSelectable = false,
  });

  @override
  _FoodCategoryItemState createState() => _FoodCategoryItemState();
}

class _FoodCategoryItemState extends State<FoodCategoryItem> with AutomaticKeepAliveClientMixin<FoodCategoryItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: widget.isRTL
          ? EdgeInsets.only(right: widget.index == 0 ? 17 : 0, left: widget.index == widget.count - 1 ? 17 : 0)
          : EdgeInsets.only(left: widget.index == 0 ? 17 : 0, right: widget.index == widget.count - 1 ? 17 : 0),
      child: InkWell(
        onTap: widget.isSelectable
            ? () {
                setState(() {
                  isSelected = !isSelected;
                  print(isSelected.toString());
                });
              }
            : () {
                print(isSelected.toString());
              },
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
                  border: isSelected ? Border.all(color: AppColors.secondaryDark, width: 2) : null,
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.transparent, AppColors.primary], // red to yellow
                  ),
                ),
                child: Text(
                  widget.category.title,
                  style: AppTextStyles.subtitleWhite,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            isSelected ? Positioned.fill(child: AppIcon.iconWhite(FontAwesomeIcons.check)) : Container()
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
