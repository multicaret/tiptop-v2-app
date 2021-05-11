import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/UI/widgets/food/restaurants/restaurant_logo_header.dart';
import 'package:tiptop_v2/UI/widgets/labeled_rating_bar.dart';
import 'package:tiptop_v2/UI/widgets/like_dislike_buttons.dart';
import 'package:tiptop_v2/UI/widgets/order_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/orders_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class FoodOrderRatingPage extends StatefulWidget {
  static const routeName = '/food-order-rating';

  @override
  _FoodOrderRatingPageState createState() => _FoodOrderRatingPageState();
}

class _FoodOrderRatingPageState extends State<FoodOrderRatingPage> {
  final GlobalKey<FormState> _ratingFormKey = GlobalKey();

  bool _isInit = true;
  bool _isLoadingCreateRatingRequest = false;
  bool _isLoadingStoreRatingRequest = false;
  Order order;
  AppProvider appProvider;
  OrdersProvider ordersProvider;

  double _ratingValue;
  Map<String, bool> _foodRatingFactors = {};
  String _ratingComments = '';
  int _selectedIssueId;

  List<FoodOrderRatingFactors> foodOrderRatingFactors = [];

  Future<void> _createOrderRating() async {
    setState(() => _isLoadingCreateRatingRequest = true);
    await ordersProvider.createOrderRating(appProvider, order.id, isMarketOrder: false);
    foodOrderRatingFactors = ordersProvider.foodOrderRatingFactors;
    foodOrderRatingFactors.forEach((factor) {
      _foodRatingFactors[factor.key] = null;
    });
    setState(() => _isLoadingCreateRatingRequest = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Map<String, dynamic> data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      order = data["order"];
      appProvider = Provider.of<AppProvider>(context);
      ordersProvider = Provider.of<OrdersProvider>(context);
      _createOrderRating();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _submitRating() async {
    _ratingFormKey.currentState.save();
    if (_ratingValue == null) {
      showToast(msg: Translations.of(context).get("Please enter a rating value!"));
    } else {
      setState(() => _isLoadingStoreRatingRequest = true);
      Map<String, dynamic> ratingData = {
        'branch_rating_value': _ratingValue,
        'comment': _ratingComments,
        //Todo: implement driver rating
        'driver_rating_value': null,
        'food_rating_factors': _foodRatingFactors,
      };
      print('ratingData');
      print(ratingData);
      try {
        await ordersProvider.storeOrderRating(appProvider, order.id, ratingData);
        setState(() => _isLoadingStoreRatingRequest = false);
        showToast(msg: Translations.of(context).get("Rating submitted successfully"));
        Navigator.of(context).pop(true);
      } catch (e) {
        showToast(msg: Translations.of(context).get("Error submitting rating!"));
        setState(() => _isLoadingStoreRatingRequest = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasOverlayLoader: _isLoadingStoreRatingRequest,
      body: _isLoadingCreateRatingRequest
          ? const AppLoader()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        OrderItem(
                          order: order,
                          isDisabled: true,
                        ),
                        RestaurantLogoHeader(restaurant: order.cart.restaurant),
                        LabeledRatingBar(setRatingValue: (value) => setState(() => _ratingValue = value)),
                        Column(
                          children: List.generate(foodOrderRatingFactors.length, (i) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: listItemVerticalPaddingSm),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border(bottom: BorderSide(color: AppColors.border)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(foodOrderRatingFactors[i].label),
                                  LikeDislikeButtons(
                                    value: _foodRatingFactors[foodOrderRatingFactors[i].key],
                                    setValue: (value) => setState(() => _foodRatingFactors[foodOrderRatingFactors[i].key] = value),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        Form(
                          key: _ratingFormKey,
                          child: Container(
                            padding: const EdgeInsets.only(left: screenHorizontalPadding, right: screenHorizontalPadding, top: 20),
                            color: AppColors.white,
                            child: AppTextField(
                              labelText: 'Your comment',
                              maxLines: 3,
                              onSaved: (value) {
                                _ratingComments = value;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: screenHorizontalPadding,
                    right: screenHorizontalPadding,
                    top: listItemVerticalPadding,
                    bottom: actionButtonBottomPadding,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    boxShadow: [const BoxShadow(color: AppColors.shadow, blurRadius: 6)],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButtons.secondary(
                          child: Text(Translations.of(context).get("Send")),
                          onPressed: _submitRating,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButtons.primary(
                          child: Text(Translations.of(context).get("Skip")),
                          onPressed: () => Navigator.of(context).pop(),
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
