import 'package:hive/hive.dart';
part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject{
  @HiveField(0)
  String cateID;

  @HiveField(1)
  String cateName;

  Category({required this.cateID, required this.cateName});
}