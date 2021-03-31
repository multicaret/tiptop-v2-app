import 'package:tiptop_v2/models/category.dart';
import 'package:tiptop_v2/models/product.dart';

import 'models/models.dart';

final List<Restaurant> dummyRestaurants = [
  Restaurant(
    id: 1,
    title: 'Some Very Very Fancy Restaurant Title 1',
    cover: 'assets/images/food.jpg',
    discountValue: '50%',
  ),
  Restaurant(
    id: 2,
    title: 'Some Very Very Fancy Restaurant Title 2',
    cover: 'assets/images/food.jpg',
  ),
  Restaurant(
    id: 3,
    title: 'Some Very Very Fancy Restaurant Title 3',
    cover: 'assets/images/food.jpg',
    discountValue: '50%',
  ),
  Restaurant(
    id: 4,
    title: 'Some Very Very Fancy Restaurant Title 4',
    cover: 'assets/images/food.jpg',
  ),
  Restaurant(
    id: 5,
    title: 'Some Very Very Fancy Restaurant Title 5',
    cover: 'assets/images/food.jpg',
    discountValue: '70%',
  ),
  Restaurant(
    id: 6,
    title: 'Some Very Very Fancy Restaurant Title 6',
    cover: 'assets/images/food.jpg',
  ),
  Restaurant(
    id: 7,
    title: 'Some Very Very Fancy Restaurant Title 7',
    cover: 'assets/images/food.jpg',
  ),
  Restaurant(
    id: 8,
    title: 'Some Very Very Fancy Restaurant Title 8',
    cover: 'assets/images/food.jpg',
    discountValue: '40%',
  ),
  Restaurant(
    id: 9,
    title: 'Some Very Very Fancy Restaurant Title 9',
    cover: 'assets/images/food.jpg',
  ),
  Restaurant(
    id: 10,
    title: 'Some Very Very Fancy Restaurant Title 10',
    cover: 'assets/images/food.jpg',
    discountValue: '30%',
  ),
  Restaurant(
    id: 11,
    title: 'Some Very Very Fancy Restaurant Title 11',
    cover: 'assets/images/food.jpg',
  ),
];

List<Category> dummyCategories = [
  Category(
    id: 1,
    title: 'Test Category 1',
    products: [
      Product(
        id: 1,
        title: 'Category 1 - Test Product 1',
      ),
      Product(
        id: 2,
        title: 'Category 1 - Test Product 2',
      ),
      Product(
        id: 3,
        title: 'Category 1 - Test Product 3',
      ),
      Product(
        id: 4,
        title: 'Category 1 - Test Product 4',
      ),
      Product(
        id: 5,
        title: 'Category 1 - Test Product 5',
      ),
      Product(
        id: 6,
        title: 'Category 1 - Test Product 6',
      ),
    ],
  ),
  Category(
    id: 2,
    title: 'Test Category 2',
    products: [
      Product(
        id: 1,
        title: 'Category 2 - Test Product 1',
      ),
      Product(
        id: 2,
        title: 'Category 2 - Test Product 2',
      ),
      Product(
        id: 3,
        title: 'Category 2 - Test Product 3',
      ),
      Product(
        id: 6,
        title: 'Category 2 - Test Product 6',
      ),
    ],
  ),
  Category(
    id: 3,
    title: 'Test Category 3',
    products: [
      Product(
        id: 1,
        title: 'Category 3 - Test Product 1',
      ),
      Product(
        id: 2,
        title: 'Category 3 - Test Product 2',
      ),
      Product(
        id: 3,
        title: 'Category 3 - Test Product 3',
      ),
      Product(
        id: 4,
        title: 'Category 3 - Test Product 4',
      ),
      Product(
        id: 5,
        title: 'Category 3 - Test Product 5',
      ),
      Product(
        id: 6,
        title: 'Category 3 - Test Product 6',
      ),
    ],
  ),
  Category(
    id: 4,
    title: 'Test Category 4',
    products: [
      Product(
        id: 5,
        title: 'Category 4 - Test Product 5',
      ),
      Product(
        id: 6,
        title: 'Category 4 - Test Product 6',
      ),
    ],
  ),
  Category(
    id: 5,
    title: 'Test Category 5',
    products: [
      Product(
        id: 5,
        title: 'Category 5 - Test Product 5',
      ),
    ],
  ),
  Category(
    id: 6,
    title: 'Test Category 6',
    products: [
      Product(
        id: 1,
        title: 'Category 6 - Test Product 1',
      ),
      Product(
        id: 2,
        title: 'Category 6 - Test Product 2',
      ),
      Product(
        id: 3,
        title: 'Category 6 - Test Product 3',
      ),
      Product(
        id: 4,
        title: 'Category 6 - Test Product 4',
      ),
      Product(
        id: 5,
        title: 'Category 6 - Test Product 5',
      ),
      Product(
        id: 6,
        title: 'Category 6 - Test Product 6',
      ),
    ],
  ),
  Category(
    id: 7,
    title: 'Test Category 7',
    products: [
      Product(
        id: 5,
        title: 'Category 7 - Test Product 5',
      ),
      Product(
        id: 6,
        title: 'Category 7 - Test Product 6',
      ),
    ],
  ),
];