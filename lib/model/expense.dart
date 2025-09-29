import 'package:hive/hive.dart';
part 'expense.g.dart';

@HiveType(typeId: 1)
class Expense extends HiveObject{
  @HiveField(0)
  String id;
  
  @HiveField(1)
  int amount;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  DateTime date;
  
  @HiveField(4)
  String category;

  Expense ({required this.id, required this.amount, required this.description, required this.date, required this.category});
}