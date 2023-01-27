import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sizer/sizer.dart';

import '../../../Controller/provider/prov_chart.dart';
import '../../../Controller/provider/prov_transactions.dart';

class ScreenOverall extends StatefulWidget {
  const ScreenOverall({super.key});

  @override
  State<ScreenOverall> createState() => _ScreenOverallState();
}

class _ScreenOverallState extends State<ScreenOverall> {
  dynamic data;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProvTransactionDB>(context, listen: false).refresh();
      dynamic inc = Provider.of<ProvTransactionDB>(context, listen: false)
          .transactionListNotifier;
      data = Provider.of<ProvChart>(context, listen: false).chartsort(inc);
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
          child: Consumer2<ProvTransactionDB, ProvChart>(
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
                        ]);
            },
          ),
        ),
      ),
    );
  }
}

// List<Overall> chartsort(List<TransactionModel> model) {
//   double value;
//   CategoryType categorytype;
//   List visited = [];
//   List<Overall> newData = [];

// //length of array cant be zero.
//   for (var i = 0; i < model.length; i++) {
//     visited.add(0);
//   }

//   for (var i = 0; i < model.length; i++) {
//     value = model[i].amount;
//     categorytype = model[i].category.type;

//     for (var j = i + 1; j < model.length; j++) {
//       if (model[i].category.type == model[j].category.type) {
//         value = value + model[j].amount;
//         visited[j] = -1;
//       }
//     }

//     if (visited[i] != -1) {
//       newData.add(Overall(
//         type: categorytype.name.toUpperCase(),
//         amount: value,
//       ));
//     }
//   }

//   return newData;
// }

// class Overall {
//   Overall({
//     required this.type,
//     required this.amount,
//   });
//   final String? type;
//   final double amount;
// }
