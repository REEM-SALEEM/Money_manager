import 'package:flutter/material.dart';
import 'package:money_manager/chart/widgets/expense.dart';
import 'package:money_manager/chart/widgets/income.dart';

class ScreenChart extends StatelessWidget {
  const ScreenChart({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 42, 41),
        appBar: AppBar(
          toolbarHeight: 10,
          centerTitle: true,
          backgroundColor: Colors.black,
          bottom: const TabBar(labelPadding: EdgeInsets.all(10), tabs: [
            Text('INCOME', style: TextStyle(fontSize: 17, color: Colors.white)),
            Text('EXPENSE',
                style: TextStyle(fontSize: 17, color: Colors.white)),
          ]),
        ),
        body: const SizedBox(
          width: 400,
          child: TabBarView(physics: BouncingScrollPhysics(), children: [
            ScreenIncomeChart(),
            ScreenExpenseChart(),
          ]),
        ),
      ),
    );
  }
}
