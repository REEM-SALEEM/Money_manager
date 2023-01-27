import 'package:hive_flutter/adapters.dart';
part 'category_model.g.dart';

@HiveType(typeId: 2)
enum CategoryType {  //name:income/expense.
  @HiveField(0)
  income,

  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final bool isDeleted;

  @HiveField(2)               //income or expense
  final CategoryType type; 

  @HiveField(3)
  final String name;

  CategoryModel({
    required this.id,
    required this.type,
    required this.name,
    this.isDeleted = false,
  });
}
