import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiptop_v2/UI/widgets/sort_bottom_sheet.dart';
import 'package:tiptop_v2/UI/widgets/triangle_painter.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class TempFoodView extends StatefulWidget {
  @override
  _TempFoodViewState createState() => _TempFoodViewState();
}

class _TempFoodViewState extends State<TempFoodView> {
  bool _showListView = true;
  bool _showGridView = false;

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 17.0, top: 17.0, bottom: 5.0),
            child: Text(Translations.of(context).get("Categories"), style: AppTextStyles.body50),
          ),
          RestaurantCategories(categoriesItems: _categoriesItems),
          FilterSortButtons(),
          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 17.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Translations.of(context).get("All Restaurants"), style: AppTextStyles.body50),
                ListDisplayButton(
                  showGridView: _showGridView,
                  showListView: _showListView,
                  onGridViewPressed: () {
                    setState(() {
                      _showGridView = !_showGridView;
                      _showListView = false;
                    });
                  },
                  onListViewPressed: () {
                    setState(() {
                      _showListView = !_showListView;
                      _showGridView = false;
                    });
                  },
                ),
              ],
            ),
          ),
          _showListView ? RestaurantListView() : RestaurantGridView(),
        ],
      ),
    );
  }
}

class RestaurantCategories extends StatelessWidget {
  const RestaurantCategories({
    Key key,
    @required List<Map<String, dynamic>> categoriesItems,
  })  : _categoriesItems = categoriesItems,
        super(key: key);

  final List<Map<String, dynamic>> _categoriesItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      color: AppColors.white,
      height: 110,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 10);
        },
        itemCount: _categoriesItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Stack(
            children: [
              Container(
                width: 116,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      _categoriesItems[i]['image'],
                    ),
                  ),
                  color: AppColors.primary50,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      _categoriesItems[i]['title'],
                      style: AppTextStyles.bodyWhite,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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

class FilterSortButtons extends StatelessWidget {
  final Function onSortButtonPressed;
  final Function onFilterButtonPressed;

  FilterSortButtons({this.onSortButtonPressed, this.onFilterButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 30.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(45)),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.filter),
                  SizedBox(width: 10),
                  Text(Translations.of(context).get("Filter")),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(45)),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => SortBottomSheet(),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.sort),
                  SizedBox(width: 10),
                  Text(Translations.of(context).get("Sort")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListDisplayButton extends StatelessWidget {
  final Function onListViewPressed;
  final Function onGridViewPressed;
  final bool showListView;
  final bool showGridView;

  ListDisplayButton({
    this.onGridViewPressed,
    this.onListViewPressed,
    this.showGridView,
    this.showListView,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: Image.asset(
            'assets/images/list-view-icon.png',
            color: showListView ? AppColors.primary : AppColors.primary50,
            width: 18,
            height: 16,
          ),
          onTap: onListViewPressed,
        ),
        SizedBox(width: 25),
        InkWell(
          child: Image.asset(
            'assets/images/grid-view-icon.png',
            color: showGridView ? AppColors.primary : AppColors.primary50,
            width: 18,
            height: 16,
          ),
          onTap: onGridViewPressed,
        ),
      ],
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
