import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../db/transaction/transaction_db.dart';
import '../../model/transaction/transaction_model.dart';
import 'package:sizer/sizer.dart';

class ScreenIncomeChart extends StatefulWidget {
  const ScreenIncomeChart({super.key});

  @override
  State<ScreenIncomeChart> createState() => _ScreenIncomeChartState();
}

class _ScreenIncomeChartState extends State<ScreenIncomeChart> {
  @override
  void initState() {
    TransactionDB.instance.refresh();
    super.initState();
  }

  final List<IncomeData> data =
      chartsort(TransactionDB.instance.incometransactionListNotifier.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 42, 41),
      body: data.isEmpty
          ? const Center(
              child: Text(
              'No data found',
              style: TextStyle(color: Colors.white),
            ))
          : Center(
              child: SizedBox(
                width: 100.w,
                height: 300,
                child: SfCircularChart(
                    legend: Legend(
                        borderWidth: 6,
                        isVisible: true,
                        textStyle: const TextStyle(color: Colors.white)),
                    series: <PieSeries>[
                      // Render pie chart
                      PieSeries<IncomeData, String>(
                        dataSource: data,
                        // pointColorMapper: ,
                        xValueMapper: (IncomeData data, _) => data.type,
                        yValueMapper: (IncomeData data, _) => data.amount,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        enableTooltip: true,
                      )
                    ]),
              ),
            ),
    );
  }
}

List<IncomeData> chartsort(List<TransactionModel> model) {
  double value;
  String categoryname;
  List visited = [];
  List<IncomeData> newData = [];

  for (var i = 0; i < model.length; i++) {
    visited.add(0);
  }

  for (var i = 0; i < model.length; i++) {
    value = model[i].amount;
    categoryname = model[i].category.name;

    for (var j = i + 1; j < model.length; j++) {
      if (model[i].category.name == model[j].category.name) {
        value = value + model[j].amount;
        visited[j] = -1;
      }
    }

    if (visited[i] != -1) {
      newData.add(IncomeData(
        type: categoryname,
        amount: value,
      ));
    }
  }

  return newData;
}

class IncomeData {
  IncomeData({
    required this.type,
    required this.amount,
  });
  final String? type;
  final double amount;
}
