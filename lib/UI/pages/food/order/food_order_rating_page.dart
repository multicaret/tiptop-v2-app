import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_rating_bar.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
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

  double ratingStarsGutter = 30;
  double _ratingValue;
  String _ratingComments = '';
  int _selectedIssueId;

  Future<void> _createOrderRating() async {
    setState(() => _isLoadingCreateRatingRequest = true);
    await ordersProvider.createOrderRating(appProvider, order.id, isMarketOrder: false);
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

  List<String> _ratingStarsLabels = [
    "Very Bad",
    "Bad",
    "Okay",
    "Good",
    "Very Good",
  ];

  Future<void> _submitRating() async {
    _ratingFormKey.currentState.save();
    if (_ratingValue == null) {
      showToast(msg: 'Please enter a rating value!');
    } else if (_ratingValue <= 2 && _selectedIssueId == null) {
      showToast(msg: 'Please select a reason!');
    } else {
      setState(() => _isLoadingStoreRatingRequest = true);
      Map<String, dynamic> ratingData = {
        'branch_rating_value': _ratingValue,
        'grocery_issue_id': _selectedIssueId,
        'comment': _ratingComments,
      };
      print('ratingData');
      print(ratingData);
      try {
        await ordersProvider.storeOrderRating(appProvider, order.id, ratingData);
        setState(() => _isLoadingStoreRatingRequest = false);
        showToast(msg: 'Rating submitted successfully');
        Navigator.of(context).pop();
      } catch (e) {
        showToast(msg: 'Error submitting rating!');
        setState(() => _isLoadingStoreRatingRequest = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

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
                            isRTL: appProvider.isRTL,
                            order: order,
                            isDisabled: true,
                          ),
                          SectionTitle('Please Rate Your Experience'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border(bottom: BorderSide(color: AppColors.border)),
                            ),
                            child: Column(
                              children: [
                                AppRatingBar(
                                  starsGutter: ratingStarsGutter,
                                  starSize: (screenSize.width - (ratingStarsGutter * 5) - (screenHorizontalPadding * 2)) / 5,
                                  onRatingUpdate: (value) {
                                    setState(() {
                                      _ratingValue = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: List.generate(
                                    _ratingStarsLabels.length,
                                    (i) => Expanded(
                                      child: Text(
                                        Translations.of(context).get(_ratingStarsLabels[i]),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Todo: Add food rating issues
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
                            child: Text(Translations.of(context).get('Send')),
                            onPressed: _submitRating,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppButtons.primary(
                            child: Text(Translations.of(context).get('Skip')),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ));
  }
}
