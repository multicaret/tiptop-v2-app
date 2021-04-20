import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_select_items.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/food/product_option_pill.dart';
import 'package:tiptop_v2/UI/widgets/formatted_prices.dart';
import 'package:tiptop_v2/UI/widgets/total_button.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import '../../widgets/UI/app_scaffold.dart';

class FoodProductPage extends StatefulWidget {
  static const routeName = '/food-product';

  @override
  _FoodProductPageState createState() => _FoodProductPageState();
}

class _FoodProductPageState extends State<FoodProductPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool _isInit = true;
  bool _isLoadingProduct = false;

  ProductsProvider productsProvider;
  AppProvider appProvider;
  int productId;
  Product product;

  bool hasDiscountedPrice = false;
  bool hasControls = true;

  List<Map<String, dynamic>> selectedProductOptions = [];
  double productTotalPrice = 0.0;

  Future<void> _fetchAndSetProduct() async {
    setState(() => _isLoadingProduct = true);
    await productsProvider.fetchAndSetProduct(appProvider, productId);
    product = productsProvider.product;
    selectedProductOptions = productsProvider.getProductCartData(product.id)['selected_options'] as List<Map<String, dynamic>>;
    productTotalPrice = productsProvider.getProductCartData(product.id)['product_total_price'];
    setState(() => _isLoadingProduct = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Map<String, dynamic> data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      productId = data["product_id"];
      hasControls = data["has_controls"] == null ? true : data["has_controls"];
      productsProvider = Provider.of<ProductsProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      _fetchAndSetProduct();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoadingProduct) {
      selectedProductOptions = productsProvider.getProductCartData(product.id)['selected_options'] as List<Map<String, dynamic>>;
      productTotalPrice = productsProvider.getProductCartData(product.id)['product_total_price'];
    }
    return AppScaffold(
      bgColor: AppColors.white,
      appBar: _isLoadingProduct
          ? null
          : AppBar(
              title: Text(product.title),
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
                        Container(
                          height: 400,
                          child: CachedNetworkImage(
                            imageUrl: product.media.cover,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
                          child: Column(
                            children: [
                              Text(
                                product.title,
                                style: AppTextStyles.h2,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              if (product.description != null && product.description.raw != null && product.description.raw.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    product.description.raw,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              FormattedPrices(
                                price: product.price,
                                discountedPrice: product.discountedPrice,
                                isLarge: true,
                              ),
                            ],
                          ),
                        ),
                        ..._getProductOptionsItems(),
                      ],
                    ),
                  ),
                ),
                Consumer<HomeProvider>(
                  builder: (c, homeProvider, _) => TotalButton(
                    isRTL: appProvider.isRTL,
                    total: priceAndCurrency(productTotalPrice, homeProvider.foodCurrency),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LineAwesomeIcons.shopping_cart,
                          color: AppColors.white,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            //Todo: text becomes "Update Cart" after being added to cart
                            Translations.of(context).get('Add To Cart'),
                            maxLines: 1,
                            style: AppTextStyles.button,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _getProductOptionsItems() {
    return List.generate(product.options.length, (i) {
      ProductOption option = product.options[i];
      Map<String, dynamic> selectedProductOption = selectedProductOptions.firstWhere(
            (selectedProductOption) => selectedProductOption["id"] == option.id,
            orElse: () => null,
          ) ??
          {
            'id': option.id,
            'selected_ids': [],
          };
      List<int> selectedIds = selectedProductOption['selected_ids'] == null ? <int>[] : selectedProductOption['selected_ids'];

      List<dynamic> getRadioItems() {
        return option.selections.map((item) {
          String itemTitle = item.price == null || item.price.raw == 0 ? item.title : '${item.title} [+${item.price.formatted}]';
          return {
            'id': item.id,
            'title': itemTitle,
          };
        }).toList();
      }

      void updateOption(int _id) {
        List<int> newSelectedIds = option.selectionType == ProductOptionSelectionType.SINGLE
            ? [_id]
            : addOrRemoveIdsFromArray(
                array: selectedIds,
                id: _id,
                maxLength: option.type == ProductOptionType.EXCLUDING ? null : option.maxNumberOfSelection,
              );

        productsProvider.setProductSelectedOption(
          productId: product.id,
          optionData: {
            'id': option.id,
            'selected_ids': newSelectedIds,
          },
          // productTotalPrice:
        );
      }

      Widget getOptionContent() {
        switch (option.inputType) {
          case ProductOptionInputType.RADIO:
            return RadioSelectItems(
              items: getRadioItems(),
              selectedId: selectedIds.length > 0 ? selectedIds[0] : null,
              action: (id) => updateOption(id),
              isRTL: appProvider.isRTL,
              hasBorder: false,
            );
            break;
          case ProductOptionInputType.PILL:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: List.generate(option.ingredients.length, (j) {
                  return ProductOptionPill(
                    text: option.ingredients[j].title,
                    price: option.ingredients[j].price,
                    onTap: () => updateOption(option.ingredients[j].id),
                    isExcluding: option.type == ProductOptionType.EXCLUDING,
                    isActive: selectedIds.contains(option.ingredients[j].id),
                  );
                }),
              ),
            );
            break;
          default:
            return Container();
        }
      }

      return Column(
        children: [
          SectionTitle(
            option.title,
            suffix: option.isRequired ? ' *' : '',
            translate: false,
          ),
          Container(
            width: double.infinity,
            color: AppColors.white,
            child: getOptionContent(),
          ),
        ],
      );
    });
  }
}
