import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/checkbox_list_items.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/radio_list_items.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/providers/products_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

import 'product_option_pill.dart';

class FoodProductOptions extends StatelessWidget {
  final Product product;

  FoodProductOptions({this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (c, productsProvider, _) {
        List<Map<String, dynamic>> selectedProductOptions = productsProvider.productTempCartData['options'] as List<Map<String, dynamic>>;

        return Column(
          children: List.generate(product.options.length, (i) {
            ProductOption option = product.options[i];
            Map<String, dynamic> selectedProductOption = selectedProductOptions.firstWhere(
              (selectedProductOption) => selectedProductOption["id"] == option.id,
              orElse: () => null,
            );
            List<int> selectedIds = selectedProductOption['selected_ids'] == null ? <int>[] : selectedProductOption['selected_ids'];

            void updateOption(int _id) {
              productsProvider.setProductTempOption(
                product: product,
                option: option,
                selectionOrIngredientId: _id,
              );
            }

            Widget getOptionContent() {
              switch (option.inputType) {
                case ProductOptionInputType.RADIO:
                  return RadioListItems(
                    items: option.selections.map((selection) {
                      return {
                        'id': selection.id,
                        'title': RichText(
                          text: TextSpan(
                            text: selection.title,
                            style: AppTextStyles.body,
                            children: <TextSpan>[
                              if (selection.price != null && selection.price.raw > 0)
                                TextSpan(
                                  text: ' [+${selection.price.formatted}]',
                                  style: AppTextStyles.bodySecondary,
                                ),
                            ],
                          ),
                        ),
                      };
                    }).toList(),
                    selectedId: selectedIds.length > 0 ? selectedIds[0] : null,
                    action: (id) => updateOption(id),
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
                case ProductOptionInputType.CHECKBOX:
                  return CheckboxListItems(
                    items: option.selections
                        .map((selection) => {
                              'id': selection.id,
                              'title': RichText(
                                text: TextSpan(
                                  text: selection.title,
                                  style: AppTextStyles.body,
                                  children: <TextSpan>[
                                    if (selection.price != null && selection.price.raw > 0)
                                      TextSpan(
                                        text: ' [+${selection.price.formatted}]',
                                        style: AppTextStyles.bodySecondary,
                                      ),
                                  ],
                                ),
                              ),
                            })
                        .toList(),
                    selectedIds: selectedIds,
                    action: (id) => updateOption(id),
                    hasBorder: false,
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
          }),
        );
      },
    );
  }
}
