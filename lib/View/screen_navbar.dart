import 'package:flutter/material.dart';
import 'package:money_manager/Controller/provider/prov_transactions.dart';
import 'package:money_manager/View/settings/screen_settings.dart';
import 'package:money_manager/View/transactions/screen_transactions.dart';
import 'package:provider/provider.dart';
import '../Controller/provider/prov_bottom.dart';
import '../Controller/provider/prov_categoryfunctions.dart';
import 'category/screen_category.dart';
import 'chart/screen_chart.dart';

class BottomNavigationScreen extends StatelessWidget {
  BottomNavigationScreen({super.key});

  int currentIndex = 0; //initial selected value(by default)

  List pages = [
    const ScreenTransactions(),
    const ScreenChart(),
    const ScreenCategory(),
    ScreenSetting(),
  ];

  @override
  Widget build(BuildContext context) {
    Provider.of<ProvTransactionDB>(context, listen: false).refresh();
    Provider.of<ProvCategoryDB>(context, listen: false).refreshUI();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<BottomProvider>(
        builder: (BuildContext context, BottomProvider value, Widget? _) {
          return pages[value.currentIndex ?? currentIndex];
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Consumer<BottomProvider>(
          builder: (BuildContext ctx, BottomProvider value, Widget? _) {
            return BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      size: 25,
                    ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.pie_chart,
                      size: 25,
                    ),
                    label: 'chart'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.category,
                      size: 25,
                    ),
                    label: 'category'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      size: 25,
                    ),
                    label: 'settings'),
              ],
              backgroundColor: Colors.black,
              selectedItemColor: const Color.fromARGB(255, 184, 252, 121),
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              currentIndex: value.currentIndex ?? currentIndex,
              onTap: (index) {
                currentIndex = index;
                value.currentIndex = index;
              },
            );
          },
        ),
      ),
    );
  }
}
