import 'package:expense_tracker/provider/expense_provider.dart';
import 'package:expense_tracker/screen/manage_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ExpenseProvider>(context,listen: false).initBox(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return LinearProgressIndicator();
          }else{
            return Scaffold(
              body: Consumer<ExpenseProvider>(
                  builder: (context,data,child){
                    return ListView.builder(
                      itemCount: data.expenses.length,
                        itemBuilder: (context,index){
                          String formattedDate = DateFormat('yyyy-MM-dd').format(data.expenses[index].date);
                          String formattedAmount = NumberFormat('#,##0').format(data.expenses[index].amount);
                          return ListTile(
                            title: Text(data.expenses[index].description),
                            subtitle: Text(formattedDate),
                            trailing: Text('$formattedAmount MMK',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),),
                          );
                        });
                  }),
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>ManageExpenseScreen())
                  );
                },
                child: Icon(Icons.add),),
            );
          }
        });
  }
}
