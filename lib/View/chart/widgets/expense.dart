import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sizer/sizer.dart';
import '../../../Controller/provider/prov_chart.dart';
import '../../../Controller/provider/prov_transactions.dart';

class ScreenExpenseChart extends StatefulWidget {
  const ScreenExpenseChart({super.key});

  @override
  State<ScreenExpenseChart> createState() => _ScreenExpenseChartState();
}

class _ScreenExpenseChartState extends State<ScreenExpenseChart> {
  dynamic data;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProvTransactionDB>(context, listen: false).refresh();
      dynamic inc = Provider.of<ProvTransactionDB>(context, listen: false)
          .transactionListNotifier;
      data = Provider.of<Expchart>(context, listen: false).chartsort(inc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 42, 41),
      body: Center(
        child: SizedBox(
          width: 100.w,
          height: 300,
          child: Consumer2<ProvTransactionDB, Expchart>(
            builder: (BuildContext context, tra, value, Widget? child) {
              return data == null ||  data.isEmpty
                  ? const Center(
                      child: Text(
                      'No data found',
                      style: TextStyle(color: Colors.white),
                    ))
                  : SfCircularChart(
                      legend: Legend(
                          borderWidth: 6,
                          isVisible: true,
                          textStyle: const TextStyle(color: Colors.white)),
                      series: <PieSeries>[
                          PieSeries<ExpenseData, String>(
                            dataSource: data,
                            xValueMapper: (ExpenseData data, _) => data.type,
                            yValueMapper: (ExpenseData data, _) => data.amount,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            enableTooltip: true,
                          )
                        ]);
            },
          ),
        ),
      ),
    );
  }
}

// //*Expense Chart
// List<ExpenseData> chartsort(List<TransactionModel> model) {
//   double value;
//   String categoryname;
//   List visited = [];
//   List<ExpenseData> newData = [];
// //array cant be null.
//   for (var i = 0; i < model.length; i++) {
//     visited.add(0);
//   }
// //iterator will store the amt and catname to a variable
//   for (var i = 0; i < model.length; i++) {
//     value = model[i].amount;
//     categoryname = model[i].category.name;

// //compare with the ith index catname if yes add both amount together
//     for (var j = i + 1; j < model.length; j++) {
//       if (model[i].category.name == model[j].category.name) {
//         value = value + model[j].amount;
//         visited[j] = -1;
//       }
//     }
// //storing in new aaray
//     if (visited[i] != -1) {
//       newData.add(ExpenseData(
//         type: categoryname,
//         amount: value,
//       ));
//     }
//   }

//   return newData;
// }

// class ExpenseData {
//   ExpenseData({
//     required this.type,
//     required this.amount,
//   });
//   final String? type;
//   final double amount;
// }
