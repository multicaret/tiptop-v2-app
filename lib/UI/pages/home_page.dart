import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/products_page.dart';
import 'package:tiptop_v2/UI/widgets/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/app_bar_cart_total.dart';
import 'package:tiptop_v2/UI/widgets/app_carousel.dart';
import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/category_item.dart';
import 'package:tiptop_v2/UI/widgets/channels_buttons.dart';
import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isLoadingHomeData = false;
  bool homeDataRequestError = false;
  bool _noBranchFound = false;
  bool _isInit = true;

  AppProvider appProvider;
  HomeProvider homeProvider;
  CartProvider cartProvider;

  EstimatedArrivalTime estimatedArrivalTime;
  List<Category> categories;

  List<String> _carouselImages = [
    'assets/images/slide-1.png',
    'assets/images/slide-2.png',
  ];

  Future<void> fetchAndSetHomeData() async {
    setState(() => isLoadingHomeData = true);
    try {
      await homeProvider.fetchAndSetHomeData(appProvider, cartProvider);
      estimatedArrivalTime = homeProvider.homeData.estimatedArrivalTime;
      categories = homeProvider.homeData.categories;

      if (homeProvider.branchId == null) setState(() => _noBranchFound = true);

      setState(() => isLoadingHomeData = false);
    } catch (e) {
      //Todo: translate this string/reconsider what to do
      showToast(msg: 'An Error Occurred! Please try again later');
      setState(() {
        homeDataRequestError = true;
        isLoadingHomeData = false;
      });
      throw e;
    }
  }

  Future<void> selectCategory(int categoryId) async {
    await homeProvider.selectCategory(categoryId);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      cartProvider = Provider.of<CartProvider>(context);
      fetchAndSetHomeData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarActions: appProvider.isAuth
          ? [
              AppBarCartTotal(isLoadingHomeData: isLoadingHomeData),
            ]
          : null,
      bodyPadding: EdgeInsets.all(0),
      body: Column(
        children: [
          AddressSelectButton(
            isLoadingHomeData: isLoadingHomeData || homeDataRequestError || _noBranchFound,
            estimatedArrivalTime: estimatedArrivalTime,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchAndSetHomeData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isLoadingHomeData || homeDataRequestError || _noBranchFound
                        ? Container(
                            height: 212,
                            color: AppColors.bg,
                          )
                        : AppCarousel(
                            images: _carouselImages,
                            autoplayDuration: Duration(milliseconds: 3000),
                          ),
                    ChannelsButtons(),
                    isLoadingHomeData || homeDataRequestError || _noBranchFound
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 50),
                            child: _noBranchFound
                                ? Text('No Branch Found')
                                : homeDataRequestError
                                    //Todo: translate this string/reconsider what to do
                                    ? Text('An error occurred! Please try again later')
                                    : AppLoader(),
                          )
                        : GridView.count(
                            padding: EdgeInsets.only(right: 17, left: 17, top: 10, bottom: 20),
                            shrinkWrap: true,
                            childAspectRatio: 0.78,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 16,
                            children: categories
                                .map((category) => GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          CupertinoPageRoute<void>(
                                            builder: (BuildContext context) => ProductsPage(
                                              selectedParentCategoryId: category.id,
                                              parents: categories,
                                              refreshHomeData: fetchAndSetHomeData,
                                              isLoadingHomeData: isLoadingHomeData,
                                            ),
                                          ),
                                        );
                                      },
                                      child: CategoryItem(
                                        title: category.title,
                                        imageUrl: category.cover,
                                      ),
                                    ))
                                .toList(),
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
