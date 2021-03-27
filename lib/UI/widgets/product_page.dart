import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/cart_controls.dart';
import 'package:tiptop_v2/UI/widgets/section_title.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'app_carousel.dart';
import 'app_scaffold.dart';
import 'formatted_price.dart';

class ProductPage extends StatefulWidget {
  static const routeName = '/product';

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _isInit = true;
  bool _isLoadingProduct = false;
  bool _isLoadingInteractRequest = false;
  bool productIsFavorited;
  ProductsProvider productsProvider;
  AppProvider appProvider;
  Product product;
  List<String> productGallery = [];
  bool hasDiscountedPrice = false;

  Future<void> _fetchAndSetProduct() async {
    setState(() => _isLoadingProduct = true);
    await productsProvider.fetchAndSetProduct(appProvider, product.id);
    product = productsProvider.product;
    productIsFavorited = product.isFavorited;
    print('productIsFavorited: $productIsFavorited');
    setState(() => _isLoadingProduct = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      product = ModalRoute.of(context).settings.arguments as Product;
      productIsFavorited = product.isFavorited;
      productsProvider = Provider.of<ProductsProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      _fetchAndSetProduct();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> interactWithProduct() async {
    bool _oldFavoriteState = productIsFavorited;
    setState(() {
      productIsFavorited = !productIsFavorited;
      _isLoadingInteractRequest = true;
    });
    try {
      await productsProvider.interactWithProduct(appProvider, product.id, _oldFavoriteState ? 'unfavorite' : 'favorite');
      setState(() => _isLoadingInteractRequest = false);
      showToast(msg: 'Successfully added product to favorites!');
    } catch (e) {
      setState(() {
        productIsFavorited = _oldFavoriteState;
        _isLoadingInteractRequest = false;
      });
      showToast(msg: "An error occurred and we couldn't add this product to your favorites!");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    productGallery = [product.media.cover, ...product.media.gallery.map((galleryItem) => galleryItem.file)];
    hasDiscountedPrice = product.discountedPrice != null && product.discountedPrice.raw != 0;

    return AppScaffold(
      bgColor: AppColors.white,
      appBar: AppBar(
        title: Text(product.title),
        leading: IconButton(
          icon: Icon(Platform.isAndroid ? Icons.clear : CupertinoIcons.clear_thick),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (appProvider.isAuth)
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _isLoadingProduct ? 0 : 1,
              child: IconButton(
                onPressed: interactWithProduct,
                icon: AppIcon.icon(productIsFavorited ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                AppCarousel(
                  height: 400,
                  hasDots: productGallery.length > 1,
                  images: productGallery,
                ),
                SizedBox(height: 20),
                Text(
                  product.title,
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                if (hasDiscountedPrice)
                  FormattedPrice(
                    price: product.discountedPrice.formatted,
                    isLarge: true,
                  ),
                FormattedPrice(
                  price: product.price.formatted,
                  isDiscounted: hasDiscountedPrice,
                  isLarge: true,
                ),
                if (product.unitText != null) Text(product.unitText, style: AppTextStyles.subtitleXs50),
                SizedBox(height: 20),
                if (product.description != null) SectionTitle('Details'),
                if (product.description != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 9),
                    child: Html(
                      data: """${product.description.formatted}""",
                    ),
                  ),
                SizedBox(height: 105),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 105,
            child: Container(
              padding: EdgeInsets.only(top: 20, bottom: 40, right: 17, left: 17),
              height: 45,
              color: AppColors.bg,
              child: CartControls(
                isModalControls: true,
                product: product,
                cartButtonHeight: 45,
              ),
            ),
          )
        ],
      ),
    );
  }
}
