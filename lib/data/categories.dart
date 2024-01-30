import 'package:flutter/material.dart';
import 'package:shopping_app/models/category.dart';

const categories = {
  Categories.vegetables: Category(
    'Vegetables',
    Colors.deepPurple,
  ),
  Categories.fruit: Category(
    'Fruit',
    Colors.lightGreen,
  ),
  Categories.meat: Category(
    'Meat',
    Color.fromARGB(255, 246, 16, 0),
  ),
  Categories.dairy: Category(
    'Dairy',
    Colors.white,
  ),
  Categories.carbs: Category(
    'Carbs',
    Colors.orange,
  ),
  Categories.sweets: Category(
    'Sweets',
    Color.fromARGB(255, 162, 108, 89),
  ),
  Categories.spices: Category(
    'Spices',
    Color.fromARGB(255, 255, 230, 0),
  ),
  Categories.other: Category(
    'Others',
    Colors.blue,
  ),
};
