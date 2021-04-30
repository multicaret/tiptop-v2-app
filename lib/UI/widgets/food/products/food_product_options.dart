import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_drop_down_button.dart';
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
  final List<ProductOption> productOptions;

  FoodProductOptions({
    @required this.product,
    @required this.productOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (c, productsProvider, _) {
        List<ProductSelectedOption> selectedProductOptions = productsProvider.productTempCartData.selectedOptions;

        return Column(
          children: List.generate(productOptions.length, (i) {
            ProductOption option = productOptions[i];
            Map<String, dynamic> optionValidation = productsProvider.getOptionValidation(option.id);

            ProductSelectedOption selectedProductOption = selectedProductOptions.firstWhere(
              (selectedProductOption) => selectedProductOption.productOptionId == option.id,
              orElse: () => null,
            );
            List<int> selectionIds = selectedProductOption.selectionIds == null ? <int>[] : selectedProductOption.selectionIds;
            List<Map<String, dynamic>> radioOrCheckboxOrDropdownItems = option.selections
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
                .toList();

            void updateOption(int _id) {
              productsProvider.setProductTempOption(
                product: product,
                option: option,
                selectionOrIngredientId: _id,
                context: context,
              );
            }

            Widget getOptionContent() {
              switch (option.inputType) {
                case ProductOptionInputType.RADIO:
                  return RadioListItems(
                    items: radioOrCheckboxOrDropdownItems,
                    selectedId: selectionIds.length > 0 ? selectionIds[0] : null,
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
                          isActive: selectionIds.contains(option.ingredients[j].id),
                        );
                      }),
                    ),
                  );
                  break;
                case ProductOptionInputType.CHECKBOX:
                  return CheckboxListItems(
                    items: radioOrCheckboxOrDropdownItems,
                    selectedIds: selectionIds,
                    action: (id) => updateOption(id),
                    hasBorder: false,
                  );
                  break;
                case ProductOptionInputType.SELECT:
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
                    child: AppDropDownButton(
                      hintText: option.title,
                      defaultValue: selectionIds.length > 0 ? selectionIds[0] : null,
                      fit: true,
                      items: radioOrCheckboxOrDropdownItems,
                      onChanged: (id) => updateOption(id),
                    ),
                  );
                default:
                  return Container();
              }
            }

            return option.selections.length == 0 && option.ingredients.length == 0
                ? Container()
                : Column(
                    children: [
                      SectionTitle(
                        option.title,
                        suffix: option.isRequired ? ' *' : null,
                        suffixTextStyle: AppTextStyles.bodySecondary,
                        translate: false,
                      ),
                      if (optionValidation != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: screenHorizontalPadding, right: screenHorizontalPadding, top: 10, bottom: 5),
                          decoration: BoxDecoration(
                            color: AppColors.bg,
                            border: Border(bottom: BorderSide(color: Colors.red)),
                          ),
                          child: Text(
                            optionValidation['message'],
                            style: AppTextStyles.subtitleXs.copyWith(color: Colors.red),
                          ),
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
