import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../db/transaction/transaction_db.dart';
import '../../model/transaction/transaction_model.dart';

class ScreenExpenseChart extends StatefulWidget {
  const ScreenExpenseChart({super.key});

  @override
  State<ScreenExpenseChart> createState() => _ScreenExpenseChartState();
}

class _ScreenExpenseChartState extends State<ScreenExpenseChart> {
  @override
  void initState() {
    TransactionDB.instance.refresh();
    super.initState();
  }

  final List<ExpenseData> data =
      chartsort(TransactionDB.instance.expensetransactionListNotifier.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 42, 41),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 08),
              child: SfCircularChart(
                  legend: Legend(
                      borderWidth: 6,
                      isVisible: true,
                      textStyle: const TextStyle(color: Colors.white)),
                  series: <PieSeries>[
                    PieSeries<ExpenseData, String>(
                      dataSource: data,
                      xValueMapper: (ExpenseData data, _) => data.type,
                      yValueMapper: (ExpenseData data, _) => data.amount,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                      enableTooltip: true,
                    )
                  ])),
        ]),
      ),
    );
  }
}

//*Expense Chart
List<ExpenseData> chartsort(List<TransactionModel> model) {
  double value;
  String categoryname;
  List visited = [];
  List<ExpenseData> newData = [];
//array cant be null.
  for (var i = 0; i < model.length; i++) {
    visited.add(0);
  }
//iterator will store the amt and catname to a variable
  for (var i = 0; i < model.length; i++) {
    value = model[i].amount;
    categoryname = model[i].category.name;

//compare with the ith index catname if yes add both amount together
    for (var j = i + 1; j < model.length; j++) {
      if (model[i].category.name == model[j].category.name) {
        value = value + model[j].amount;
        visited[j] = -1;
      }
    }
//storing in new aaray
    if (visited[i] != -1) {
      newData.add(ExpenseData(
        type: categoryname,
        amount: value,
      ));
    }
  }

  return newData;
}

class ExpenseData {
  ExpenseData({
    required this.type,
    required this.amount,
  });
  final String? type;
  final double amount;
}
