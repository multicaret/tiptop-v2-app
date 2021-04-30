import 'package:flutter/material.dart';
import 'package:tiptop_v2/models/cart.dart';
import 'package:tiptop_v2/models/product.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class SelectedOptionsText extends StatelessWidget {
  final CartProduct cartProduct;

  SelectedOptionsText({@required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    List<ProductOption> fullSelectedOptions = cartProduct.selectedOptions.map((selectedOption) {
      ProductOption targetOption = cartProduct.product.options.firstWhere(
        (option) => option.id == selectedOption.productOptionId,
        orElse: () => null,
      );
      List<ProductOptionSelection> selectedSelectionsOrIngredients = <ProductOptionSelection>[];
      if (targetOption != null) {
        List<ProductOptionSelection> targetSelectionsOrIngredients =
            targetOption.isBasedOnIngredients ? targetOption.ingredients : targetOption.selections;
        selectedSelectionsOrIngredients = selectedOption.selectedIds.map((selectedId) {
          ProductOptionSelection targetSelectionOrIngredient =
              targetSelectionsOrIngredients.firstWhere((selectionOrIngredient) => selectionOrIngredient.id == selectedId, orElse: () => null);
          if (targetSelectionOrIngredient != null) {
            return ProductOptionSelection(
              id: selectedId,
              title: targetSelectionOrIngredient.title,
              price: targetSelectionOrIngredient.price,
            );
          }
        }).toList();
      }
      return ProductOption(
        id: targetOption.id,
        title: targetOption.title,
        selections: selectedSelectionsOrIngredients,
      );
    }).toList();

    return fullSelectedOptions.length == 0
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              fullSelectedOptions.length,
              (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: RichText(
                    text: TextSpan(
                      text: '${fullSelectedOptions[i].title}: ',
                      style: AppTextStyles.subtitleXsSecondary,
                      children: List.generate(fullSelectedOptions[i].selections.length, (j) {
                        ProductOptionSelection selection = fullSelectedOptions[i].selections[j];
                        if (selection != null) {
                          String selectionText =
                              selection.price.raw > 0 ? ' ${selection.title} [+${selection.price.formatted}]' : ' ${selection.title}';
                          return TextSpan(
                            text: selectionText + (j == fullSelectedOptions[i].selections.length - 1 ? '' : ', '),
                            style: AppTextStyles.subtitleXs50,
                          );
                        } else {
                          return TextSpan();
                        }
                      }),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
