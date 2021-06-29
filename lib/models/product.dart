import 'enums.dart';
import 'models.dart';

class Product {
  Product({
    this.id,
    this.branchId,
    this.chainId,
    this.uuid,
    this.englishTitle,
    this.title,
    this.description,
    this.excerpt,
    this.notes,
    this.customBannerText,
    this.availableQuantity,
    this.unitText,
    this.sku,
    this.upc,
    this.minimumOrderableQuantity,
    this.avgRating,
    this.ratingCount,
    this.price,
    this.discountedPrice,
    this.barcodes,
    this.media,
    this.width,
    this.height,
    this.depth,
    this.weight,
    this.isFavorited,
    this.options,
    this.unit,
    this.isDisabled,
  });

  int id;
  int branchId;
  int chainId;
  String uuid;
  String englishTitle;
  String title;
  StringRawStringFormatted description;
  StringRawStringFormatted excerpt;
  StringRawStringFormatted notes;
  dynamic customBannerText;
  int availableQuantity;
  String unitText;
  String sku;
  dynamic upc;
  int minimumOrderableQuantity;
  String avgRating;
  int ratingCount;
  DoubleRawStringFormatted price;
  DoubleRawStringFormatted discountedPrice;
  List<dynamic> barcodes;
  Media media;
  double width;
  double height;
  double depth;
  double weight;
  bool isFavorited;
  List<ProductOption> options;
  Unit unit;
  bool isDisabled;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        branchId: json["branchId"],
        chainId: json["chainId"],
        uuid: json["uuid"],
        englishTitle: json["englishTitle"],
        title: json["title"],
        description: json["description"] == null ? null : StringRawStringFormatted.fromJson(json["description"]),
        excerpt: json["excerpt"] == null ? null : StringRawStringFormatted.fromJson(json["excerpt"]),
        notes: json["notes"] == null ? null : StringRawStringFormatted.fromJson(json["notes"]),
        customBannerText: json["customBannerText"],
        availableQuantity: json["availableQuantity"],
        unitText: json["unitText"],
        sku: json["sku"],
        upc: json["upc"],
        minimumOrderableQuantity: json["minimumOrderableQuantity"],
        avgRating: json["avgRating"],
        ratingCount: json["ratingCount"],
        price: DoubleRawStringFormatted.fromJson(json["price"]),
        discountedPrice: json["discountedPrice"] == null ? null : DoubleRawStringFormatted.fromJson(json["discountedPrice"]),
        barcodes: json["barcodes"] == null ? null : List<dynamic>.from(json["barcodes"].map((x) => x)),
        media: Media.fromJson(json["media"]),
        width: json["width"] == null ? null : json["width"].toDouble(),
        height: json["height"] == null ? null : json["height"].toDouble(),
        depth: json["depth"] == null ? null : json["depth"].toDouble(),
        weight: json["weight"] == null ? null : json["weight"].toDouble(),
        isFavorited: json["isFavorited"],
        options: json["options"] == null ? <ProductOption>[] : List<ProductOption>.from(json["options"].map((x) => ProductOption.fromJson(x))),
        unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
        isDisabled: json["isDisabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "englishTitle": englishTitle,
        "title": title,
        "description": description,
        "excerpt": excerpt,
        "notes": notes,
        "customBannerText": customBannerText,
        "availableQuantity": availableQuantity,
        "unitText": unitText,
        "sku": sku,
        "upc": upc,
        "minimumOrderableQuantity": minimumOrderableQuantity,
        "avgRating": avgRating,
        "ratingCount": ratingCount,
        "price": price.toJson(),
        "discountedPrice": discountedPrice == null ? null : discountedPrice.toJson(),
        "barcodes": barcodes == null ? null : List<dynamic>.from(barcodes.map((x) => x)),
        "media": media.toJson(),
        "width": width,
        "height": height,
        "depth": depth,
        "weight": weight,
        "isFavorited": isFavorited,
        "unit": unit == null ? null : unit.toJson(),
        "isDisabled": isDisabled,
      };
}

class ProductOption {
  ProductOption({
    this.id,
    this.isBasedOnIngredients,
    this.isRequired,
    this.type,
    this.title,
    this.maxNumberOfSelection,
    this.minNumberOfSelection,
    this.inputType,
    this.selectionType,
    this.selections,
    this.ingredients,
  });

  int id;
  bool isBasedOnIngredients;
  bool isRequired;
  ProductOptionType type;
  String title;
  int maxNumberOfSelection;
  int minNumberOfSelection;
  ProductOptionInputType inputType;
  ProductOptionSelectionType selectionType;
  List<ProductOptionSelection> selections;
  List<ProductOptionSelection> ingredients;

  factory ProductOption.fromJson(Map<String, dynamic> json) => ProductOption(
        id: json["id"],
        isBasedOnIngredients: json["isBasedOnIngredients"],
        isRequired: json["isRequired"],
        type: productOptionTypeValues.map[json["type"]],
        title: json["title"],
        maxNumberOfSelection: json["maxNumberOfSelection"],
        minNumberOfSelection: json["minNumberOfSelection"],
        inputType: productOptionInputTypeValues.map[json["inputType"]],
        selectionType: productOptionSelectionTypeValues.map[json["selectionType"]],
        selections: json["selections"] == null
            ? <ProductOptionSelection>[]
            : List<ProductOptionSelection>.from(json["selections"].map((x) => ProductOptionSelection.fromJson(x))),
        ingredients: json["ingredients"] == null
            ? <ProductOptionSelection>[]
            : List<ProductOptionSelection>.from(json["ingredients"].map((x) => ProductOptionSelection.fromJson(x))),
      );
}

class ProductOptionSelection {
  ProductOptionSelection({
    this.id,
    this.title,
    this.price,
  });

  int id;
  String title;
  DoubleRawStringFormatted price;

  factory ProductOptionSelection.fromJson(Map<String, dynamic> json) => ProductOptionSelection(
        id: json["id"],
        title: json["title"],
        price: DoubleRawStringFormatted.fromJson(json["price"]),
      );
}

class Unit {
  Unit({
    this.id,
    this.title,
    this.step,
  });

  int id;
  String title;
  String step;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        title: json["title"],
        step: json["step"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "step": step,
      };
}

class ProductCartData {
  ProductCartData({
    this.productId,
    this.selectedOptions,
    this.productTotalPrice,
    this.quantity,
  });

  int productId;
  List<ProductSelectedOption> selectedOptions;
  double productTotalPrice;
  int quantity;

  factory ProductCartData.fromJson(Map<String, dynamic> json) => ProductCartData(
        productId: json["productId"],
        selectedOptions: List<ProductSelectedOption>.from(json["selectedOptions"].map((x) => ProductSelectedOption.fromJson(x))),
        productTotalPrice: json["productTotalPrice"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "selectedOptions": List<dynamic>.from(selectedOptions.map((x) => x.toJson())),
        "productTotalPrice": productTotalPrice,
        "quantity": quantity,
      };
}

class ProductSelectedOption {
  ProductSelectedOption({
    this.productOptionId,
    this.selectionIds,
    this.optionTotalPrice,
  });

  int productOptionId;
  List<int> selectionIds;
  double optionTotalPrice;

  factory ProductSelectedOption.fromJson(Map<String, dynamic> json) => ProductSelectedOption(
        productOptionId: json["productOptionId"],
        selectionIds: json["selectionIds"] == null ? null : List<int>.from(json["selectionIds"].map((x) => x)),
        optionTotalPrice: json["optionTotalPrice"] == null ? 0.0 : json["optionTotalPrice"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "productOptionId": productOptionId,
        "selectionIds": List<int>.from(selectionIds.map((x) => x)),
        "optionTotalPrice": optionTotalPrice,
      };
}
