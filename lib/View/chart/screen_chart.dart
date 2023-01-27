import 'package:flutter/material.dart';
import 'package:money_manager/View/chart/widgets/expense.dart';
import 'package:money_manager/View/chart/widgets/income.dart';
import 'package:money_manager/View/chart/widgets/overall.dart';

class ScreenChart extends StatelessWidget {
  const ScreenChart({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 42, 41),
        appBar: AppBar(
          toolbarHeight: 10,
          centerTitle: true,
          backgroundColor: Colors.black,
          bottom: const TabBar(labelPadding: EdgeInsets.all(10), tabs: [
            Text('OVERALL',
                style: TextStyle(fontSize: 17, color: Colors.white)),
            Text('INCOME', style: TextStyle(fontSize: 17, color: Colors.white)),
            Text('EXPENSE',
                style: TextStyle(fontSize: 17, color: Colors.white)),
          ]),
        ),
        body: const TabBarView(physics: BouncingScrollPhysics(), children: [
          ScreenOverall(),
          ScreenIncomeChart(),
          ScreenExpenseChart(),
        ]),
      ),
    );
  }
}
