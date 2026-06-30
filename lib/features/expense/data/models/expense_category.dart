import 'package:hive/hive.dart';

part 'expense_category.g.dart';

@HiveType(typeId: 1)
enum ExpenseCategoryModel {
  @HiveField(0)
  food,

  @HiveField(1)
  shopping,

  @HiveField(2)
  travel,

  @HiveField(3)
  utilities,

  @HiveField(4)
  entertainment,

  @HiveField(5)
  others,
}
