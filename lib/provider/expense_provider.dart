import 'dart:math';

import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ExpenseProvider with ChangeNotifier{
  List<Expense> expenses = [];
  // final Box box = Hive.box<Expense>("expenses");
  late Box<Expense> box;

  Future<void> initBox() async {
    box = await Hive.openBox<Expense>("expenses");
    fetchItemFromHiveDB();
  }

  String getTodayExpenses() {
    int total = 0;
    DateTime today = DateTime.now();
    for(Expense e in expenses){
      if(e.date.year == today.year && e.date.month == today.month && e.date.day == today.day){
        total += e.amount;
      }
    }
    return NumberFormat('#,##0').format(total);
  }

  Map<String, int> getTotalExpensesByCategory(){
    Map<String,int> data ={};
    Set<String> categories = expenses.map((e)=> e.category).toSet();
    for(String cat in categories){
      int total = 0;
      List<Expense> filterExpenses = expenses.where((e)=>e.category == cat).toList();
      for(Expense fe in filterExpenses){
        total += fe.amount;
      }
      data[cat] = total;
    }

    return data;
  }

  void fetchItemFromHiveDB(){
    expenses = box.values.toList().reversed.toList();
    notifyListeners();
  }

  void addItem(Expense expense){
    box.add(expense);
    expenses.insert(0, expense);
    notifyListeners();
  }

  void deleteItem(int index){
    box.deleteAt(index);
    expenses.removeAt(index);
    notifyListeners();
  }

  void updateItem(int index, Expense expense){
    box.putAt(index, expense);
    expenses[index] = expense;
    notifyListeners();
  }
}