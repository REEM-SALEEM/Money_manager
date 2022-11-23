import 'package:flutter/material.dart';
import 'package:money_manager/category/widgets/expense.dart';
import 'package:money_manager/category/widgets/expense_popup.dart';
import 'package:money_manager/category/widgets/income.dart';
import 'package:money_manager/category/widgets/income_popup.dart';
import 'package:sizer/sizer.dart';
import '../db/category/category_db.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

int indexTab = 0;

class _ScreenCategoryState extends State<ScreenCategory> {
  @override
  void initState() {
    CategoryDB().refreshUI();
    setState(() {
      FloatingActionButton;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //To control the tabs (no. of tabs == length)
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
            centerTitle: true,
            title: const Text("Categories",
                style: TextStyle(fontSize: 20, color: Colors.white)),
            backgroundColor: Colors.black),
        body: Container(
          height: 80.h,
          // height: 705,
          // width: 900,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0)),
            color: Color.fromARGB(255, 17, 17, 17),
          ),
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
                child: Container(
                  height: 55,
                  width: 350,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 87, 84, 84),
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(11)),
                  //----Tab bar
                  child: TabBar(
                      onTap: (index) {
                        setState(() {
                          indexTab = index;
                        });
                      },
                      labelColor: Colors.white,
                      indicator: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      tabs: const [
                        Tab(
                          text: 'Income',
                        ),
                        Tab(text: 'Expense')
                      ]),
                ),
              ),
              const SizedBox(
                  width: 400,
                  height: 507,
                  child: TabBarView(children: [Income(), Expense()]))
            ]),
          ),
        ),
        floatingActionButton: indexTab == 0
            ? FloatingActionButton(
                onPressed: () {
                  showIncomepopup(context);
                },
                backgroundColor: Colors.black,
                foregroundColor: const Color.fromARGB(255, 184, 252, 121),
                child: const Icon(Icons.add, size: 30),
              )
            : FloatingActionButton(
                onPressed: () {
                  showExpensepopup(context);
                },
                backgroundColor: Colors.black,
                foregroundColor: Colors.orangeAccent,
                child: const Icon(Icons.add, size: 30)),
      ),
    );
  }
}
