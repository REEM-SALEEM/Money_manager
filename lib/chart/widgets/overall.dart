import 'package:flutter/material.dart';
import 'package:money_manager/model/category/category_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../db/transaction/transaction_db.dart';
import '../../model/transaction/transaction_model.dart';
import 'package:sizer/sizer.dart';

class ScreenOverall extends StatefulWidget {
  const ScreenOverall({super.key});

  @override
  State<ScreenOverall> createState() => _ScreenOverallState();
}

class _ScreenOverallState extends State<ScreenOverall> {
  @override
  void initState() {
    TransactionDB.instance.refresh();
    super.initState();
  }

  final List<Overall> data =
      chartsort(TransactionDB.instance.transactionListNotifier.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 42, 41),
      body: data.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: Center(
                  child: Text(
                'No data found',
                style: TextStyle(color: Colors.white),
              )),
            )
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
                      PieSeries<Overall, String>(
                        dataSource: data,
                        // pointColorMapper: ,
                        xValueMapper: (Overall data, _) => data.type,
                        yValueMapper: (Overall data, _) => data.amount,
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

List<Overall> chartsort(List<TransactionModel> model) {
  double value;
  CategoryType categorytype;
  List visited = [];
  List<Overall> newData = [];

//length of array cant be zero.
  for (var i = 0; i < model.length; i++) {
    visited.add(0);
  }

  for (var i = 0; i < model.length; i++) {
    value = model[i].amount;
    categorytype = model[i].category.type;

    for (var j = i + 1; j < model.length; j++) {
      if (model[i].category.type == model[j].category.type) {
        value = value + model[j].amount;
        visited[j] = -1;
      }
    }

    if (visited[i] != -1) {
      newData.add(Overall(
        type: categorytype.name.toUpperCase(),
        amount: value,
      ));
    }
  }

  return newData;
}

class Overall {
  Overall({
    required this.type,
    required this.amount,
  });
  final String? type;
  final double amount;
}
