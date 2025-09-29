import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/provider/category_provider.dart';
import 'package:expense_tracker/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../model/category.dart';

class ManageExpenseScreen extends StatefulWidget {
  const ManageExpenseScreen({super.key});

  @override
  State<ManageExpenseScreen> createState() => _ManageExpenseScreenState();
}

class _ManageExpenseScreenState extends State<ManageExpenseScreen> {
  final amountController = TextEditingController();
  final descController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String? selectedCategory;

  Future<void> initCategoryData() async{
    await Provider.of<CategoryProvider>(context,listen: false).initBox();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initCategoryData();
    super.initState();
  }

  Widget buildCategorySelector(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    return DropdownButton<String>(
      value: selectedCategory,
        underline: const SizedBox(),
        isExpanded: true,
        hint: Text('Choose Category'),
        items: [
      for (Category c in provider.categories)
        DropdownMenuItem(
            value: c.cateName,
            child: Text(c.cateName))
    ], onChanged: (String? selectedValue) {
      setState(() {
        selectedCategory = selectedValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage Expense'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildCategorySelector(context),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    validator: (value){
                      return value==null || value.isEmpty ? 'Enter Amount' : null;
                    },
                    decoration: InputDecoration(
                      label: Text('Amount'),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: descController,
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    validator: (value){
                      return value==null || value.isEmpty ? 'Enter Description' : null;
                    },
                    decoration: InputDecoration(
                        label: Text('Description'),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey
                      ),
                        onPressed: () async{
                          if(formKey.currentState!.validate() && selectedCategory != null){
                            Uuid uuid = Uuid();
                            DateTime now = DateTime.now();
                            DateTime today = DateTime(now.year,now.month,now.day);
                            Provider.of<ExpenseProvider>(context,listen: false).addItem(
                              Expense(
                                  id: uuid.v4(),
                                  amount: int.parse(amountController.text.trim()),
                                  description: descController.text.trim(),
                                  date: today,
                                  category: selectedCategory!)
                            );

                            Navigator.pop(context);
                          }
                        },
                        child: Text('Save')),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
