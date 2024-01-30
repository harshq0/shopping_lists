import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/models/grocery_items.dart';

final groceryIems = [
  CategoryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categories[Categories.dairy]!),
  CategoryItem(
      id: 'b',
      name: 'apple',
      quantity: 5,
      category: categories[Categories.fruit]!),
  CategoryItem(
      id: 'c',
      name: 'gulab jamun',
      quantity: 10,
      category: categories[Categories.sweets]!),
];
