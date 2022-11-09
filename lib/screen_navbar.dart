import 'package:flutter/material.dart';
import 'package:money_manager/transactions/screen_transactions.dart';
import 'package:money_manager/category/screen_category.dart';
import 'package:money_manager/chart/screen_chart.dart';
import 'package:money_manager/settings/screen_settings.dart';

import 'db/category/category_db.dart';
import 'db/transaction/transaction_db.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  @override
  initState() {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    super.initState();
  }

  int currentIndex = 0; //initial selected value(by default)

  List pages = [
    const ScreenTransactions(),
    const ScreenChart(),
    const ScreenCategory(),
    const ScreenSetting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: pages[currentIndex], //content to be displayed inside body.
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    size: 25, color: Color.fromARGB(255, 134, 255, 82)),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart,
                    size: 25, color: Color.fromARGB(255, 134, 255, 82)),
                label: 'chart'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category,
                    size: 25, color: Color.fromARGB(255, 134, 255, 82)),
                label: 'category'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings,
                    size: 25, color: Color.fromARGB(255, 134, 255, 82)),
                label: 'settings'),
          ],
          backgroundColor: Colors.black,
          unselectedItemColor: const Color.fromARGB(255, 184, 252, 121),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
// Color.fromARGB(255, 184, 252, 121)