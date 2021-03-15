import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/app_carousel.dart';
import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/category_item.dart';
import 'package:tiptop_v2/UI/widgets/channels_buttons.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  bool isLoadingHomeData = false;
  bool _isInit = true;
  AppProvider appProvider;
  HomeProvider homeProvider;
  EstimatedArrivalTime estimatedArrivalTime;
  List<Category> categories;

  List<String> _carouselImages = [
    'assets/images/slide-1.png',
    'assets/images/slide-2.png',
  ];

  Future<void> _fetchAndSetHomeData() async {
    setState(() {
      isLoadingHomeData = true;
    });

    await homeProvider.fetchAndSetHomeData();
    estimatedArrivalTime = homeProvider.homeData.estimatedArrivalTime;
    categories = homeProvider.homeData.categories;

    setState(() {
      isLoadingHomeData = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      _fetchAndSetHomeData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddressSelectButton(
          isLoadingHomeData: isLoadingHomeData,
          estimatedArrivalTime: estimatedArrivalTime,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchAndSetHomeData,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isLoadingHomeData
                      ? Container(
                          height: 212,
                          child: AppLoader(),
                        )
                      : AppCarousel(
                          images: _carouselImages,
                          autoplayDuration: Duration(milliseconds: 3000),
                        ),
                  ChannelsButtons(),
                  isLoadingHomeData
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: AppLoader(),
                        )
                      : GridView.count(
                          padding: EdgeInsets.only(right: 17, left: 17, top: 10, bottom: 20),
                          shrinkWrap: true,
                          childAspectRatio: 0.7,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 16,
                          children: categories
                              .map((category) => CategoryItem(
                                    title: category.title,
                                    imageUrl: category.cover,
                                  ))
                              .toList(),
                        )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
