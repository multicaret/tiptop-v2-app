import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_text_field.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_select_items.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/labeled_rating_bar.dart';
import 'package:tiptop_v2/UI/widgets/order_item.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/orders_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_buttons.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';

class MarketOrderRatingPage extends StatefulWidget {
  static const routeName = '/market-order-rating';

  @override
  _MarketOrderRatingPageState createState() => _MarketOrderRatingPageState();
}

class _MarketOrderRatingPageState extends State<MarketOrderRatingPage> {
  final GlobalKey<FormState> _ratingFormKey = GlobalKey();

  bool _isInit = true;
  bool _isLoadingCreateRatingRequest = false;
  bool _isLoadingStoreRatingRequest = false;
  Order order;
  AppProvider appProvider;
  OrdersProvider ordersProvider;
  List<MarketOrderRatingAvailableIssue> marketOrderRatingAvailableIssues = [];

  double _ratingValue;
  String _ratingComments = '';
  int _selectedIssueId;

  Future<void> _createOrderRating() async {
    setState(() => _isLoadingCreateRatingRequest = true);
    await ordersProvider.createOrderRating(appProvider, order.id);
    marketOrderRatingAvailableIssues = ordersProvider.marketOrderRatingAvailableIssues;
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
                          LabeledRatingBar(setRatingValue: (value) => setState(() => _ratingValue = value)),
                          if (_ratingValue != null && _ratingValue <= 2)
                            RadioSelectItems(
                              items: marketOrderRatingAvailableIssues.map((issue) => {'id': issue.id, 'title': issue.title}).toList(),
                              selectedId: _selectedIssueId,
                              action: (int id) {
                                setState(() {
                                  _selectedIssueId = id;
                                });
                              },
                              isRTL: appProvider.isRTL,
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
