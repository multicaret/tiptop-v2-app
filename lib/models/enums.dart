//To get the enum use values.map[]
//To get the string use values.reverse[]

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

//To get the enum use values.reverse[]
//To get the string use values.map[]

class EnumReverseValues<T> {
  Map<T, String> map;
  Map<String, T> reverseMap;

  EnumReverseValues(this.map);

  Map<String, T> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

enum GoogleResponseStatus {
  OK,
  ZERO_RESULTS,
  OVER_QUERY_LIMIT,
  REQUEST_DENIED,
  INVALID_REQUEST,
  UNKNOWN_ERROR,
}

final googleResponseStatusValues = EnumValues({
  "OK": GoogleResponseStatus.OK,
  "ZERO_RESULTS": GoogleResponseStatus.ZERO_RESULTS,
  "OVER_QUERY_LIMIT": GoogleResponseStatus.OVER_QUERY_LIMIT,
  "REQUEST_DENIED": GoogleResponseStatus.REQUEST_DENIED,
  "INVALID_REQUEST": GoogleResponseStatus.INVALID_REQUEST,
  "UNKNOWN_ERROR": GoogleResponseStatus.UNKNOWN_ERROR,
});

enum ForceUpdate { DISABLED, SOFT, HARD }

final forceUpdateValues = EnumValues({
  "0": ForceUpdate.DISABLED,
  "1": ForceUpdate.SOFT,
  "2": ForceUpdate.HARD,
});

enum ListType { HORIZONTALLY_STACKED, VERTICALLY_STACKED }

enum CartAction { ADD, REMOVE }

enum Interaction { FAVORITE, UN_FAVORITE }

final interactionValues = EnumValues({
  "favorite": Interaction.FAVORITE,
  "unfavorite": Interaction.UN_FAVORITE,
});

enum RestaurantDeliveryType { TIPTOP, RESTAURANT }

final restaurantDeliveryTypeValues = EnumValues({
  "tiptop": RestaurantDeliveryType.TIPTOP,
  "restaurant": RestaurantDeliveryType.RESTAURANT,
});

enum RestaurantSortType { SMART, RATING, DISTANCE }

final restaurantSortTypeValues = EnumValues({
  "smart_sorting": RestaurantSortType.SMART,
  "restaurants_rating": RestaurantSortType.RATING,
  "by_distance": RestaurantSortType.DISTANCE,
});

//Order Statuses

// CANCELLED = 0;
// DRAFT = 1;
// NEW = 2; // Pending approval or rejection,
// PREPARING = 10; // Confirmed
// WAITING_COURIER = 12; // Ready, this case is ignored when delivery is made by the branch itself
// ON_THE_WAY = 16;
// AT_THE_ADDRESS = 18;
// DELIVERED = 20;
// SCHEDULED = 25;

enum OrderStatus {
  CANCELLED,
  DRAFT,
  NEW,
  PREPARING,
  WAITING_COURIER,
  ON_THE_WAY,
  AT_THE_ADDRESS,
  DELIVERED,
  SCHEDULED,
}

final orderStatusValues = EnumValues({
  "0": OrderStatus.CANCELLED,
  "1": OrderStatus.DRAFT,
  "2": OrderStatus.NEW,
  "10": OrderStatus.PREPARING,
  "12": OrderStatus.WAITING_COURIER,
  "16": OrderStatus.ON_THE_WAY,
  "18": OrderStatus.AT_THE_ADDRESS,
  "20": OrderStatus.DELIVERED,
  "25": OrderStatus.SCHEDULED,
});

final orderStatusStringValues = EnumReverseValues({
  OrderStatus.CANCELLED: "Cancelled",
  OrderStatus.DRAFT: "Draft",
  OrderStatus.NEW: "Preparing",
  OrderStatus.PREPARING: "Preparing",
  OrderStatus.WAITING_COURIER: "Preparing",
  OrderStatus.ON_THE_WAY: "On the Way",
  OrderStatus.AT_THE_ADDRESS: "At The Address",
  OrderStatus.DELIVERED: "Delivered",
  OrderStatus.SCHEDULED: "Scheduled",
});

enum ProductOptionType {
  EXCLUDING,
  INCLUDING,
}

final productOptionTypeValues = EnumValues({
  "excluding": ProductOptionType.EXCLUDING,
  "including": ProductOptionType.INCLUDING,
});

enum ProductOptionInputType {
  PILL,
  RADIO,
  CHECKBOX,
  SELECT,
}

final productOptionInputTypeValues = EnumValues({
  "pill": ProductOptionInputType.PILL,
  "radio": ProductOptionInputType.RADIO,
  "checkbox": ProductOptionInputType.CHECKBOX,
  "select": ProductOptionInputType.SELECT,
});

enum ProductOptionSelectionType {
  SINGLE,
  MULTIPLE,
}

final productOptionSelectionTypeValues = EnumValues({
  "single": ProductOptionSelectionType.SINGLE,
  "multiple": ProductOptionSelectionType.MULTIPLE,
});

enum AppChannel {
  FOOD,
  MARKET,
}

final appChannelValues = EnumValues({
  "food": AppChannel.FOOD,
  "grocery": AppChannel.MARKET,
});

final appChannelRealValues = EnumValues({
  "food": AppChannel.FOOD,
  "market": AppChannel.MARKET,
});

enum LinkType { EXTERNAL, DEEPLINK }

final linkTypeValues = EnumValues({
  "1": LinkType.EXTERNAL,
  "4": LinkType.DEEPLINK,
});

enum TrackingEvent {
  VISIT,
  COMPLETE_REGISTRATION, //User completes registration ( no matter Whatsapp or SMS)
  VIEW_HOME, //When user visits Food / Market Home
  VIEW_CATEGORY, //if food, food category is viewd, if market the market category (Child + parent)
  VIEW_RESTAURANT_MENU, //User view any restaurant menu
  VIEW_PRODUCT_DETAILS,
  ADD_PRODUCT_TO_CART,
  VIEW_CHECKOUT,
  COMPLETE_PURCHASE,
}

final trackingEventsValues = EnumValues({
  "Visit": TrackingEvent.VISIT,
  "Complete Registration": TrackingEvent.COMPLETE_REGISTRATION,
  "View Home": TrackingEvent.VIEW_HOME,
  "View Category": TrackingEvent.VIEW_CATEGORY,
  "View Restaurant Menu": TrackingEvent.VIEW_RESTAURANT_MENU,
  "View Product Details": TrackingEvent.VIEW_PRODUCT_DETAILS,
  "Add Product To Cart": TrackingEvent.ADD_PRODUCT_TO_CART,
  "Initiate Checkout": TrackingEvent.VIEW_CHECKOUT,
  "Purchase": TrackingEvent.COMPLETE_PURCHASE,
});
