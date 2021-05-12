import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/address/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/track_order_info_container.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/order.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/orders_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrackMarketOrderPage extends StatefulWidget {
  static const routeName = '/track-market-order';

  @override
  _TrackMarketOrderPageState createState() => _TrackMarketOrderPageState();
}

class _TrackMarketOrderPageState extends State<TrackMarketOrderPage> {
  bool _isInit = true;
  bool _isLoadingWebView = true;
  bool _webViewError = false;
  bool _isLoadingOrderRequest = false;

  HomeProvider homeProvider;
  OrdersProvider ordersProvider;
  AppProvider appProvider;
  int orderId;
  Order order;

  Completer<WebViewController> _controller = Completer<WebViewController>();

  Future<void> _fetchAndSetPreviousOrder() async {
    setState(() => _isLoadingOrderRequest = true);
    await ordersProvider.fetchAndSetPreviousOrder(appProvider, orderId);
    order = ordersProvider.order;
    setState(() => _isLoadingOrderRequest = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      homeProvider = Provider.of<HomeProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      ordersProvider = Provider.of<OrdersProvider>(context);
      final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      orderId = data["order_id"];
      _fetchAndSetPreviousOrder();
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AppScaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).get("Track your order")),
      ),
      body: _isLoadingOrderRequest
          ? AppLoader()
          : Column(
              children: [
                AddressSelectButton(
                  isDisabled: true,
                  addressKindIcon: order.address.kind.icon,
                  addressKindTitle: order.address.kind.title,
                  addressText: order.address.address1,
                  forceAddressView: true,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: screenSize.height,
                        width: double.infinity,
                        child: order.trackingLink == null
                            ? Padding(
                                padding: const EdgeInsets.all(50),
                                child: Text(
                                  "${Translations.of(context).get("Reference Code")}: ${order.referenceCode}",
                                  style: AppTextStyles.body50,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : WebView(
                                initialUrl: order.trackingLink,
                                // initialUrl: 'https://captain.trytiptop.app/tracking/index.html?jobID=5708ffe709627fa5848968489dd08b69',
                                javascriptMode: JavascriptMode.unrestricted,
                                onPageStarted: (_) => setState(() => _isLoadingWebView = true),
                                onPageFinished: (_) => setState(() => _isLoadingWebView = false),
                                onWebResourceError: (_) => setState(() {
                                  _isLoadingWebView = false;
                                  _webViewError = true;
                                }),
                                onWebViewCreated: (WebViewController webViewController) {
                                  _controller.complete(webViewController);
                                },
                              ),
                      ),
                      if (_isLoadingWebView && order.trackingLink != null)
                        Positioned.fill(
                          child: Container(
                            color: AppColors.bg,
                            child: AppLoader(),
                          ),
                        ),
                      if (_webViewError)
                        Positioned.fill(
                          child: Container(
                            color: AppColors.bg,
                            padding: const EdgeInsets.all(30),
                            child: Center(
                              child: Text(Translations.of(context).get("An error occurred!")),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        child: TrackOrderInfoContainer(order: order),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
