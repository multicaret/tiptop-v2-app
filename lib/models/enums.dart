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

enum Interaction {FAVORITE, UN_FAVORITE}

String getInteractionValue(Interaction _interaction) {
  switch(_interaction) {
    case Interaction.FAVORITE:
      return "favorite";
    break;
    case Interaction.UN_FAVORITE:
      return "unfavorite";
    break;
    default:
      return "";
    break;
  }
}

enum RestaurantDeliveryType { TIPTOP, RESTAURANT }

String getRestaurantDeliveryTypeString(RestaurantDeliveryType _type) {
  switch(_type) {
    case RestaurantDeliveryType.TIPTOP:
      return "tiptop";
      break;
    case RestaurantDeliveryType.RESTAURANT:
      return "restaurant";
      break;
    default:
      return "";
      break;
  }
}

enum RestaurantSortType {SMART, RATING, DISTANCE}

String getRestaurantSortTypeString(RestaurantSortType _type) {
  switch(_type) {
    case RestaurantSortType.SMART:
      return "smart_sorting";
      break;
    case RestaurantSortType.RATING:
      return "restaurant_rating";
      break;
    case RestaurantSortType.DISTANCE:
      return "by_distance";
      break;
    default:
      return "";
      break;
  }
}