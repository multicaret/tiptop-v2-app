import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/triangle_painter.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/UI/widgets/food/filter_sort_buttons.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

enum ListType { HORIZONTALLY_STACKED, VERTICALLY_STACKED }

class TempFoodView extends StatefulWidget {
  @override
  _TempFoodViewState createState() => _TempFoodViewState();
}

class _TempFoodViewState extends State<TempFoodView> {
  ListType activeListType = ListType.HORIZONTALLY_STACKED;

  final List<Map<String, dynamic>> _categoriesItems = [
    {
      'title': "Burger",
      'image': 'assets/images/slide-2.png',
    },
    {
      'title': "Kebap",
      'image': 'assets/images/slide-2.png',
    },
    {
      'title': "Ice Cream",
      'image': 'assets/images/slide-2.png',
    },
    {
      'title': "Deserts",
      'image': 'assets/images/slide-2.png',
    },
  ];

  final List<Map<String, dynamic>> _listTypes = [
    {
      'type': ListType.HORIZONTALLY_STACKED,
      'icon': 'assets/images/list-view-icon.png',
    },
    {
      'type': ListType.VERTICALLY_STACKED,
      'icon': 'assets/images/grid-view-icon.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 17.0, top: 17.0, bottom: 5.0),
            child: Text(Translations.of(context).get("Categories"), style: AppTextStyles.body50),
          ),
          CategoriesSlider(categoriesItems: _categoriesItems, isRTL: appProvider.isRTL),
          FilterSortButtons(),
          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 17.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Translations.of(context).get("All Restaurants"), style: AppTextStyles.body50),
                Row(
                  children: List.generate(
                    _listTypes.length,
                    (i) => InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(right: i == 0 ? appProvider.isRTL ? 0 : 25 : 0, left: i == 0 ? appProvider.isRTL ? 25 : 0 : 0),
                        child: Image.asset(
                          _listTypes[i]['icon'],
                          color: activeListType == _listTypes[i]['type'] ? AppColors.primary : AppColors.primary50,
                          width: 18,
                          height: 16,
                        ),
                      ),
                      onTap: () => setState(() => activeListType = _listTypes[i]['type']),
                    ),
                  ),
                ),
              ],
            ),
          ),
          activeListType == ListType.HORIZONTALLY_STACKED ? RestaurantListView() : RestaurantGridView(),
        ],
      ),
    );
  }
}

class RestaurantListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, i) {
          return Container(
            height: 133,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: AppColors.primary50)),
              color: AppColors.white,
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 116,
                      width: 116,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage(
                            'assets/images/slide-2.png',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                          color: Colors.black.withOpacity(0.8),
                        ),
                        height: 29,
                        width: 116,
                        child: RatingRow(isListView: true),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sed ut perspiciatis unde omnis iste natus…'),
                      Column(
                        children: [
                          Row(
                            children: [
                              TipTopDeliveryIcon(),
                              EstimatedTimePriceRow(estimatedTime: '15-20', minFee: '25 IQD'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              RestaurantDeliveryIcon(),
                              EstimatedTimePriceRow(estimatedTime: '25-30', minFee: '50 IQD'),
                            ],
                          ),
                        ],
                      ),
                    ],
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

class RestaurantGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height + 100,
      padding: const EdgeInsets.only(left: 17.0, right: 17.0, top: 5.0),
      color: AppColors.white,
      child: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return Container(
            height: 287,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 173,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage(
                            'assets/images/slide-2.png',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        width: 125,
                        height: 25,
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: AppColors.secondaryDark,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.tag,
                              size: 16,
                            ),
                            SizedBox(width: 5.0),
                            Expanded(
                              child: Text(
                                '50% discount',
                                style: AppTextStyles.subtitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: AppColors.white,
                          ),
                          child: RatingRow(isListView: false),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.heart, color: AppColors.secondaryDark),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
                Text('Burger - kara mah'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TipTopDeliveryIcon(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                child: Text(
                                  Translations.of(context).get("TipTop delivery"),
                                  style: AppTextStyles.subtitle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          EstimatedTimePriceRow(estimatedTime: '15-20', minFee: '25 IQD'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              RestaurantDeliveryIcon(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                child: Text(
                                  Translations.of(context).get("Restaurant delivery"),
                                  style: AppTextStyles.subtitle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          EstimatedTimePriceRow(estimatedTime: '25-30', minFee: '50 IQD'),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 30,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: AppColors.primary,
                          ),
                          child: Center(
                            child: Text(
                              '%50',
                              style: AppTextStyles.subtitleXxsSecondary,
                            ),
                          ),
                        ),
                        CustomPaint(
                          size: Size(28.0, 5.0),
                          painter: TrianglePainter(isDown: true, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RatingRow extends StatelessWidget {
  final bool isListView;

  RatingRow({this.isListView});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(FontAwesomeIcons.solidStar, color: AppColors.secondaryDark, size: 16),
        SizedBox(width: isListView ? 0 : 4),
        Text('4.5', style: AppTextStyles.bodySecondaryDark),
        SizedBox(width: isListView ? 0 : 4),
        Text(
          '(350+)',
          style: AppTextStyles.dynamicValues(
            color: isListView ? AppColors.white.withOpacity(0.50) : AppColors.primary50,
            fontSize: 14.0,
          ),
        )
      ],
    );
  }
}

class RestaurantDeliveryIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'R',
          style: AppTextStyles.subtitleXxsSecondary,
        ),
      ),
    );
  }
}

class TipTopDeliveryIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        //TODO: change tiptop man.
        FontAwesomeIcons.male,
        color: AppColors.secondaryDark,
        size: 10,
      ),
    );
  }
}

class ListTypePicker extends StatelessWidget {
  final Function action;
  final ListType activeListType;

  ListTypePicker({
    this.action,
    this.activeListType,
  });

  final List<Map<String, dynamic>> _listTypes = [
    {
      'type': ListType.HORIZONTALLY_STACKED,
      'icon': 'assets/images/list-view-icon.png',
    },
    {
      'type': ListType.VERTICALLY_STACKED,
      'icon': 'assets/images/grid-view-icon.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        _listTypes.length,
        (i) => InkWell(
          child: Image.asset(
            _listTypes[i]['icon'],
            color: activeListType == _listTypes[i]['type'] ? AppColors.primary : AppColors.primary50,
            width: 18,
            height: 16,
          ),
          onTap: () => action(_listTypes[i]['type']),
        ),
      ),
    );
  }
}

class EstimatedTimePriceRow extends StatelessWidget {
  final String estimatedTime;
  final String minFee;

  EstimatedTimePriceRow({this.estimatedTime, this.minFee});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(FontAwesomeIcons.hourglassHalf, color: AppColors.primary50, size: 17),
        Text(estimatedTime, style: AppTextStyles.dynamicValues(color: AppColors.primary50)),
        SizedBox(width: 10),
        Row(
          children: [
            Icon(
              FontAwesomeIcons.shoppingBasket,
              color: AppColors.primary50,
              size: 17,
            ),
            SizedBox(width: 5),
            Text(
              minFee,
              style: AppTextStyles.dynamicValues(color: AppColors.primary50),
            ),
          ],
        ),
      ],
    );
  }
}
