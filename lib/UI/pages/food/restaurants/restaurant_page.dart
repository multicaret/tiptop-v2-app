import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/rating_info.dart';
import 'package:tiptop_v2/UI/widgets/food/delivery_info.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_list_item_cover.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_search_field.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class RestaurantPage extends StatelessWidget {
  static const routeName = '/restaurant';

  @override
  Widget build(BuildContext context) {
    Restaurant restaurant = ModalRoute.of(context).settings.arguments as Restaurant;
    return AppScaffold(
      hasCurve: false,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            stretch: true,
            onStretchTrigger: () async {
              print('Pulled down!');
            },
            expandedHeight: 460.0,
            collapsedHeight: 70,
            backgroundColor: AppColors.bg,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Transform.translate(
                offset: const Offset(0, 0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                  color: AppColors.bg,
                  child: RestaurantSearchField(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
              ],
              centerTitle: true,
              titlePadding: EdgeInsets.all(0),
              background: Column(
                children: [
                  Stack(
                    children: [
                      RestaurantListItemCover(
                        restaurant: restaurant,
                        isFavorited: false,
                        hasRating: false,
                        hasBorderRadius: false,
                        height: 240,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 17,
                        left: 17,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColors.border),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                constraints: BoxConstraints(minHeight: 100),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                padding: EdgeInsets.only(left: 130, top: 20, bottom: 20, right: 15),
                                margin: EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      restaurant.title,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Closing 12:18',
                                            maxLines: 1,
                                            style: AppTextStyles.subtitle50,
                                          ),
                                        ),
                                        RatingInfo(
                                          ratingValue: 4.5,
                                          ratingsCount: 350,
                                          hasWhiteBg: true,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 15,
                                height: 100,
                                width: 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset('assets/images/restaurant-logo.png'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 17, right: 17, bottom: 75),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 3)),
                        ],
                      ),
                      child: Column(
                        children: [
                          DeliveryInfo(),
                          SizedBox(height: 10),
                          DeliveryInfo(isRestaurant: true),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: 300,
                  color: Colors.red,
                  child: Center(
                    child: Text('Foo'),
                  ),
                ),
                Container(
                  height: 300,
                  color: Colors.blue,
                  child: Center(
                    child: Text('Foo'),
                  ),
                ),
                Container(
                  height: 300,
                  color: Colors.green,
                  child: Center(
                    child: Text('Foo'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}