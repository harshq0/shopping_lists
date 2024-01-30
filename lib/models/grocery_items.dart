import 'package:shopping_app/models/category.dart';

class CategoryItem {
  final String id;
  final String name;
  final int quantity;
  final Category category;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });
}
