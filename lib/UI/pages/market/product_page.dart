import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/formatted_prices.dart';
import 'package:tiptop_v2/UI/widgets/market/cart_controls.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../../widgets/UI/app_carousel.dart';
import '../../widgets/UI/app_scaffold.dart';

class ProductPage extends StatefulWidget {
  static const routeName = '/product';

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
  Product product;
  List<String> productGallery = [];
  bool hasDiscountedPrice = false;
  bool hasControls = true;

  Future<void> _fetchAndSetProduct() async {
    setState(() => _isLoadingProduct = true);
    await productsProvider.fetchAndSetProduct(appProvider, product.id);
    product = productsProvider.product;
    productIsFavorited = product.isFavorited;
    setState(() => _isLoadingProduct = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Map<String, dynamic> data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      product = data["product"];
      hasControls = data["has_controls"];
      productsProvider = Provider.of<ProductsProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      _fetchAndSetProduct();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> interactWithProduct() async {
    bool _productIsFavorited = productIsFavorited;
    setState(() {
      productIsFavorited = !productIsFavorited;
      _isLoadingInteractRequest = true;
    });
    try {
      await productsProvider.interactWithProduct(appProvider, product.id, _productIsFavorited ? 'unfavorite' : 'favorite');
      setState(() => _isLoadingInteractRequest = false);
      showToast(msg: _productIsFavorited ? 'Successfully removed product from favorites!' : 'Successfully added product to favorites!');
    } catch (e) {
      setState(() {
        productIsFavorited = _productIsFavorited;
        _isLoadingInteractRequest = false;
      });
      showToast(msg: "An error occurred and we couldn't add this product to your favorites!");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    productGallery = [product.media.cover, ...product.media.gallery.map((galleryItem) => galleryItem.file)];

    return AppScaffold(
      bgColor: AppColors.white,
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          if (appProvider.isAuth)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isLoadingProduct ? 0 : 1,
              child: IconButton(
                onPressed: _isLoadingInteractRequest ? null : interactWithProduct,
                icon: AppIcons.icon(productIsFavorited ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchAndSetProduct,
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  AppCarousel(
                    height: MediaQuery.of(context).size.width * 0.8,
                    images: productGallery,
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
                  if (product.description != null) SectionTitle('Details'),
                  if (product.description != null)
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
              padding: const EdgeInsets.only(top: 20, bottom: 40, right: screenHorizontalPadding, left: screenHorizontalPadding),
              height: 105,
              color: AppColors.bg,
              child: Container(
                constraints: BoxConstraints(maxHeight: 45),
                height: 45,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: AppColors.shadow, blurRadius: 6),
                  ],
                ),
                child: CartControls(
                  isModalControls: true,
                  product: product,
                ),
              ),
            )
        ],
      ),
    );
  }
}
