import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/formatted_prices.dart';
import 'package:tiptop_v2/UI/widgets/market/market_cart_controls.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/event_tracking.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../../widgets/UI/app_carousel.dart';
import '../../widgets/UI/app_scaffold.dart';

class MarketProductPage extends StatefulWidget {
  // static const routeName = '/market-product';
  final int productId;
  final bool hasControls;
  final String categoryEnglishTitle;
  final String parentCategoryEnglishTitle;

  MarketProductPage({
    this.productId,
    this.hasControls,
    this.categoryEnglishTitle,
    this.parentCategoryEnglishTitle,
  });

  @override
  _MarketProductPageState createState() => _MarketProductPageState();
}

class _MarketProductPageState extends State<MarketProductPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool _isInit = true;
  bool _isLoadingProduct = false;
  bool _isLoadingInteractRequest = false;
  bool productIsFavorited = false;
  ProductsProvider productsProvider;
  AppProvider appProvider;
  int productId;
  Product product;
  List<String> productGallery = [];
  bool hasDiscountedPrice = false;
  bool hasControls = true;
  bool hasUnitTitle = false;

  String categoryEnglishTitle;
  String parentCategoryEnglishTitle;

  Future<void> _fetchAndSetProduct() async {
    setState(() => _isLoadingProduct = true);
    await productsProvider.fetchAndSetProduct(appProvider, productId);
    product = productsProvider.product;
    hasUnitTitle = product.unit != null && product.unit.title != null;
    hasDiscountedPrice = product.discountedPrice != null && product.discountedPrice.raw != 0 && product.discountedPrice.raw < product.price.raw;
    productIsFavorited = product.isFavorited;
    setState(() => _isLoadingProduct = false);
  }

  Future<void> interactWithProduct() async {
    bool _productIsFavorited = productIsFavorited;
    setState(() {
      productIsFavorited = !productIsFavorited;
      _isLoadingInteractRequest = true;
    });
    try {
      await productsProvider.interactWithProduct(
        appProvider,
        product.id,
        _productIsFavorited ? Interaction.UN_FAVORITE : Interaction.FAVORITE,
      );
      setState(() => _isLoadingInteractRequest = false);
      showToast(
          msg: _productIsFavorited
              ? Translations.of(context).get("Successfully removed product from favorites!")
              : Translations.of(context).get("Successfully added product to favorites!"));
    } catch (e) {
      setState(() {
        productIsFavorited = _productIsFavorited;
        _isLoadingInteractRequest = false;
      });
      showToast(msg: Translations.of(context).get("An error occurred and we couldn't add this product to your favorites!"));
      throw e;
    }
  }

  EventTracking eventTracking = EventTracking.getActions();

  Future<void> trackViewProductDetailsEvent() async {
    Map<String, dynamic> eventParams = {
      'product_name': product.englishTitle,
      //Todo: get categoryEnglishTitle & parentCategoryEnglishTitle from API (product show endpoint)
      'product_category': categoryEnglishTitle,
      'product_parent_category': parentCategoryEnglishTitle,
      'product_cost': hasDiscountedPrice ? product.discountedPrice.raw : product.price.raw,
      'product_id': product.id,
      //Todo: check if the next 2 params are correct
      'product_ingredients': product.description != null && product.description.raw != null && product.description.raw.isNotEmpty,
    };
    await eventTracking.trackEvent(TrackingEvent.VIEW_PRODUCT_DETAILS, eventParams);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productId = widget.productId;
      hasControls = widget.hasControls ?? true;
      categoryEnglishTitle = widget.categoryEnglishTitle;
      parentCategoryEnglishTitle = widget.parentCategoryEnglishTitle;

      productsProvider = Provider.of<ProductsProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      _fetchAndSetProduct().then((_) {
        trackViewProductDetailsEvent();
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bgColor: AppColors.white,
      appBar: _isLoadingProduct
          ? null
          : AppBar(
              title: Text(product.title),
              actions: [
                if (appProvider.isAuth)
                  IconButton(
                    onPressed: _isLoadingInteractRequest ? null : interactWithProduct,
                    icon: AppIcons.icon(productIsFavorited ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart),
                  ),
              ],
            ),
      body: _isLoadingProduct
          ? AppLoader()
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchAndSetProduct,
                    child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        AppCarousel(
                          height: MediaQuery.of(context).size.width * 0.8,
                          images: product.media.gallery.map((galleryItem) => galleryItem.file).toList(),
                          hasIndicator: true,
                          infinite: false,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          product.title,
                          style: AppTextStyles.h2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        FormattedPrices(
                          price: product.price,
                          discountedPrice: product.discountedPrice,
                          isLarge: true,
                        ),
                        if (product.unitText != null) Text(product.unitText, style: AppTextStyles.subtitleXs50),
                        const SizedBox(height: 20),
                        if (product.description.formatted != null) SectionTitle('Details'),
                        if (product.description.formatted != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9),
                            child: Html(
                              data: """${product.description.formatted}""",
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (hasControls)
                  Container(
                    padding: const EdgeInsets.only(
                      top: listItemVerticalPadding,
                      bottom: actionButtonBottomPadding,
                      right: screenHorizontalPadding,
                      left: screenHorizontalPadding,
                    ),
                    height: hasUnitTitle ? actionButtonContainerHeight + 20 : actionButtonContainerHeight,
                    color: AppColors.bg,
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(maxHeight: buttonHeightSm),
                          height: buttonHeightSm,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: AppColors.shadow, blurRadius: 6),
                            ],
                          ),
                          child: MarketCartControls(
                            isModalControls: true,
                            product: product,
                          ),
                        ),
                        if (hasUnitTitle)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              product.unit.title,
                              style: AppTextStyles.subtitleXs50,
                              textAlign: TextAlign.center,
                            ),
                          )
                      ],
                    ),
                  )
              ],
            ),
    );
  }
}
