import 'dart:math';

import 'package:expense_tracker/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData{
  String label;
  int amount;
  ChartData({required this.label,required this.amount});
}

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context,listen: false);
    Map <String, int> data = provider.getTotalExpensesByCategory();
    // print(data);
    List<ChartData> chartData = data.entries.map((e)=> ChartData(label: e.key, amount: e.value)).toList();
    double maxValue = chartData.map((cd)=>cd.amount).reduce((a,b)=> a>b ? a : b).toDouble(); //comparator function

    return Consumer<ExpenseProvider>(
        builder: (context,data,child){
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 600,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),
                  labelRotation: 90,
                 ),
                primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),
                  minimum: 0,
                  maximum: maxValue+100000 ,
                  interval: 30000,
                ),
                title: ChartTitle(
                  text: 'Expenses by Category',
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: [
                  ColumnSeries<ChartData,dynamic>(
                    dataSource: chartData,
                      xValueMapper: (chartData,_)=>chartData.label,
                      yValueMapper: (chartData,_)=>chartData.amount,
                  pointColorMapper: (chartData,_){
                      Random random = Random();
                      return Color.fromRGBO(
                          random.nextInt(256),
                          random.nextInt(256),
                          random.nextInt(256),
                          1
                      );
                  },
                  width: 0.6,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)
                  ),)
                ],
              ),
            ),
          );
    });
  }
}
