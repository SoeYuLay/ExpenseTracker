import 'package:expense_tracker/model/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class CategoryProvider with ChangeNotifier {
  // final Box box = Hive.box<Category>("categories");
  List<Category> categories = [];
  late Box<Category> box;

  Future<void> initBox() async {
    box = await Hive.openBox<Category>("categories");
    fetchItemFromHiveDB();
  }


  void fetchItemFromHiveDB() {
    //data fetching
    categories = box.values.toList();
    print('Categories ${categories.length}');
    notifyListeners();
  }

  void addItem(Category category){
    box.add(category);  //add data in db
    categories.add(category); //add data in local data list
    notifyListeners();
  }

  void deleteItem(int index){
    box.deleteAt(index); //delete data in db
    categories.removeAt(index); //delete in local data list
    notifyListeners();
  }

  void updateItem(int index, Category category){
    box.putAt(index, category); //update data in db
    categories[index] = category; //update in local data list
    notifyListeners();
  }
}
